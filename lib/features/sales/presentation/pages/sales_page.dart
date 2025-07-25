import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../../domain/usecases/get_sales_report.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          context.read<ReportsBloc>()..add(const LoadTodayReport()),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView> {
  int? editingIndex;
  String? editingField; // 'name' o 'quantity'
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con título y selector de fecha
              _buildHeader(context),
              const SizedBox(height: 24),
              // Pill para el título 'Reportes'
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'Reportes de Ventas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Contenido del reporte
              Expanded(
                child: BlocBuilder<ReportsBloc, ReportsState>(
                  builder: (context, state) {
                    if (state is ReportsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ReportsLoaded) {
                      return _buildReportContent(context, state.report);
                    } else if (state is ReportsEmpty) {
                      return _buildEmptyState(context, state.date);
                    } else if (state is ReportsError) {
                      return _buildErrorState(context, state.message);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<ReportsBloc, ReportsState>(
                    builder: (context, state) {
                      String dateText = 'Hoy';
                      if (state is ReportsLoaded || state is ReportsEmpty) {
                        final date = state is ReportsLoaded
                            ? state.report.date
                            : (state as ReportsEmpty).date;
                        dateText = DateFormat('dd/MM/yyyy').format(date);
                      }
                      return Text(
                        dateText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {
            context.read<ReportsBloc>().add(const LoadTodayReport());
          },
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.primary,
          ),
          tooltip: 'Actualizar',
        ),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context, DailySalesReport report) {
    return Column(
      children: [
        // Resumen del día
        _buildDailySummary(context, report),
        const SizedBox(height: 16),
        // Lista de productos vendidos
        Expanded(child: _buildProductsList(context, report.productReports)),
      ],
    );
  }

  Widget _buildDailySummary(BuildContext context, DailySalesReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primary.withAlpha((0.08 * 255).toInt()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.primary.withAlpha((0.18 * 255).toInt()),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Resumen del día',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(report.date),
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Productos vendidos',
                  '${report.productReports.length}',
                  Icons.inventory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total vendido',
                  '${report.totalDailyAmount} CUP',
                  Icons.attach_money,
                  isMoney: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon, {
    bool isMoney = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isMoney ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: isMoney
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<SalesReport> products) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          // Header de la lista
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Producto',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Cant.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Precio',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Lista de productos
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductItem(context, product, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    SalesReport product,
    int index,
  ) {
    final isEven = index % 2 == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven
            ? Theme.of(context).cardColor
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: editingIndex == index && editingField == 'name'
                ? TextField(
                    controller: nameController,
                    autofocus: true,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) => _finishEditingName(value),
                  )
                : GestureDetector(
                    onTap: () => _startEditing(index, product, 'name'),
                    child: Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: editingIndex == index && editingField == 'quantity'
                ? TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (value) => _finishEditingQuantity(value),
                  )
                : GestureDetector(
                    onTap: () => _startEditing(index, product, 'quantity'),
                    child: Text(
                      '${product.totalQuantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              '${product.pricePerUnit} CUP',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${product.totalAmount} CUP',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DateTime date) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No hay ventas registradas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'para el ${DateFormat('dd/MM/yyyy').format(date)}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar reportes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ReportsBloc>().add(const LoadTodayReport());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      context.read<ReportsBloc>().add(LoadDailyReport(picked));
    }
  }

  void _startEditing(int index, SalesReport product, String field) {
    setState(() {
      editingIndex = index;
      editingField = field;
      if (field == 'quantity') {
        quantityController.text = product.totalQuantity.toString();
        Future.delayed(const Duration(milliseconds: 100), () {
          quantityController.selection = TextSelection.fromPosition(
            TextPosition(offset: quantityController.text.length),
          );
        });
      } else if (field == 'name') {
        nameController.text = product.productName;
        Future.delayed(const Duration(milliseconds: 100), () {
          nameController.selection = TextSelection.fromPosition(
            TextPosition(offset: nameController.text.length),
          );
        });
      }
    });
  }

  void _finishEditingQuantity(String value) {
    if (editingIndex == null) return;
    final newQuantity = int.tryParse(value);
    if (newQuantity != null && newQuantity >= 0) {
      final state = context.read<ReportsBloc>().state;
      if (state is ReportsLoaded) {
        final product = state.report.productReports[editingIndex!];
        context.read<ReportsBloc>().add(
          EditProductSales(
            productName: product.productName,
            newQuantity: newQuantity,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingrese una cantidad válida')),
      );
    }
    setState(() {
      editingIndex = null;
      editingField = null;
      quantityController.clear();
    });
  }

  void _finishEditingName(String value) async {
    if (editingIndex == null) return;
    final newName = value.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }
    // final reportsState = context.read<ReportsBloc>().state;
    // if (reportsState is ReportsLoaded) {
    //   final product = reportsState.report.productReports[editingIndex!];
    //   // Buscar el producto original por nombre
    //   // final productBloc = context.read<ProductBloc>();
    //   // final productState = productBloc.state;
    //   // if (productState is ProductsLoaded) {
    //   //   Product? original;
    //   //   try {
    //   //     original = productState.products.firstWhere(
    //   //       (p) => p.name == product.productName,
    //   //     );
    //   //   } catch (_) {
    //   //     original = null;
    //   //   }
    //   //   if (original != null) {
    //   //     final updated = original.copyWith(
    //   //       name: newName,
    //   //       updatedAt: DateTime.now(),
    //   //     );
    //   //     productBloc.add(UpdateProduct(updated));
    //   //     // Refrescar el reporte tras editar
    //   //     context.read<ReportsBloc>().add(LoadTodayReport());
    //   //   } else {
    //   //     ScaffoldMessenger.of(context).showSnackBar(
    //   //       const SnackBar(
    //   //         content: Text(
    //   //           'No se encontró el producto original para actualizar.',
    //   //         ),
    //   //       ),
    //   //     );
    //   //     setState(() {
    //   //       editingIndex = null;
    //   //       editingField = null;
    //   //       nameController.clear();
    //   //     });
    //   //     return;
    //   //   }
    //   // }
    // }
    setState(() {
      editingIndex = null;
      editingField = null;
      nameController.clear();
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
