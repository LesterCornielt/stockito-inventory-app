import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stockito/l10n/app_localizations.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../../domain/usecases/get_sales_report.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/presentation/bloc/product_event.dart';
import '../../../products/presentation/bloc/product_state.dart';
import 'dart:async';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ReportsBloc>()..add(const LoadTodayReport()),
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
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductUpdated) {
          context.read<ReportsBloc>().add(const LoadTodayReport());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTitle(context),
                const SizedBox(height: 16),
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
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        AppLocalizations.of(context)!.translate('sales_reports'),
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  BlocBuilder<ReportsBloc, ReportsState>(
                    builder: (context, state) {
                      String dateText = AppLocalizations.of(
                        context,
                      )!.translate('today');
                      if (state is ReportsLoaded || state is ReportsEmpty) {
                        final date = state is ReportsLoaded
                            ? state.report.date
                            : (state as ReportsEmpty).date;
                        dateText = DateFormat('dd/MM/yyyy').format(date);
                      }
                      return Text(
                        dateText,
                        style: theme.textTheme.titleMedium?.copyWith(
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
          icon: Icon(Icons.refresh, color: colorScheme.primary),
          tooltip: AppLocalizations.of(context)!.translate('refresh'),
        ),
      ],
    );
  }

  Widget _buildReportContent(BuildContext context, DailySalesReport report) {
    return Column(
      children: [
        _buildDailySummary(context, report),
        const SizedBox(height: 16),
        Expanded(child: _buildProductsList(context, report.productReports)),
      ],
    );
  }

  Widget _buildDailySummary(BuildContext context, DailySalesReport report) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primaryContainer),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('daily_summary'),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(report.date),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
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
                  AppLocalizations.of(context)!.translate('products_sold'),
                  '${report.productReports.length}',
                  Icons.inventory,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  AppLocalizations.of(context)!.translate('total_sold'),
                  '${report.totalDailyAmount} ${AppLocalizations.of(context)!.translate('currency')}',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isMoney ? Colors.green.shade600 : colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, List<SalesReport> products) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    AppLocalizations.of(context)!.translate('product'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('quantity_short'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('price'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.translate('total'),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
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
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
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
                    style: theme.textTheme.bodyMedium?.copyWith(
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
          Expanded(
            child: Text(
              '${product.pricePerUnit} ${AppLocalizations.of(context)!.translate('currency')}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '${product.totalAmount} ${AppLocalizations.of(context)!.translate('currency')}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DateTime date) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.translate('no_sales_registered'),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)!.translate('for_date')} ${DateFormat('dd/MM/yyyy').format(date)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: colorScheme.error.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.translate('error_loading_reports'),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ReportsBloc>().add(const LoadTodayReport());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: Text(AppLocalizations.of(context)!.translate('retry')),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('enter_valid_quantity'),
          ),
        ),
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
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('name_not_empty'),
          ),
        ),
      );
      return;
    }
    final reportsState = context.read<ReportsBloc>().state;
    if (reportsState is ReportsLoaded) {
      final product = reportsState.report.productReports[editingIndex!];
      final productBloc = context.read<ProductBloc>();
      final productState = productBloc.state;

      if (productState is ProductsLoaded) {
        Product? original;
        try {
          original = productState.products.firstWhere(
            (p) => p.name == product.productName,
          );
        } catch (_) {
          original = null;
        }

        if (original != null) {
          final updated = original.copyWith(
            name: newName,
            updatedAt: DateTime.now(),
          );
          productBloc.add(UpdateProduct(updated));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.translate('product_not_found'),
              ),
            ),
          );
        }
      }
    }
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
