import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockito/l10n/app_localizations.dart';
import '../../presentation/bloc/product_bloc.dart';
import '../../presentation/bloc/product_event.dart';
import '../../presentation/bloc/product_state.dart';
import '../../domain/entities/product.dart';
import '../../../../core/utils/persistence_service.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductListView();
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de búsqueda en la parte superior
              _SearchBar(),
              const SizedBox(height: 24),
              // Pill para el título 'Productos'
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('products'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Lista de productos
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductsLoaded) {
                      return _buildProductList(state.products, context);
                    } else if (state is ProductsEmpty) {
                      if (state.searchQuery != null &&
                          state.searchQuery!.isNotEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.translate('no_product_found'),
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            AppLocalizations.of(
                              context,
                            )!.translate('no_products_yet'),
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                    } else if (state is ProductUpdated) {
                      return _buildProductList(state.products, context);
                    } else if (state is ProductCreated) {
                      return _buildProductList(state.products, context);
                    } else if (state is ProductOperationLoading) {
                      return _buildProductList(state.products, context);
                    } else if (state is ProductError) {
                      return Center(child: Text(state.message));
                    } else if (state is ProductDeleted) {
                      return _buildProductList(state.products, context);
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
}

// Reemplazar _SampleDialogCheckbox por un widget estático

// Mover esta función fuera de cualquier clase
Widget _buildProductList(List<Product> products, BuildContext context) {
  // Ordenar productos alfabéticamente por nombre (A-Z)
  final sortedProducts = List<Product>.from(products)
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  if (sortedProducts.isEmpty) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.translate('no_products_yet'),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
  return ListView.separated(
    itemCount: sortedProducts.length,
    separatorBuilder: (_, __) => const SizedBox(height: 1),
    itemBuilder: (context, index) {
      final product = sortedProducts[index];
      return Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 16),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditDialog(
                          context,
                          product,
                          context.read<ProductBloc>(),
                        );
                      } else if (value == 'delete') {
                        _showDeleteDialog(
                          context,
                          product,
                          context.read<ProductBloc>(),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.translate('edit'),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.delete,
                              size: 16,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.translate('delete'),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.translate('quantity')}: ${product.stock}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: product.stock > 0
                            ? () {
                                context.read<ProductBloc>().add(
                                  RegisterSale(
                                    productId: product.id!,
                                    quantitySold: 1,
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.remove, size: 16),
                        style: IconButton.styleFrom(
                          backgroundColor: product.stock > 0
                              ? Colors.red.shade100
                              : Colors.grey.shade200,
                          foregroundColor: product.stock > 0
                              ? Colors.red.shade700
                              : Colors.grey.shade500,
                          minimumSize: const Size(24, 24),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          final updatedProduct = product.copyWith(
                            stock: product.stock + 1,
                            updatedAt: DateTime.now(),
                          );
                          context.read<ProductBloc>().add(
                            UpdateProduct(updatedProduct),
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.green.shade700,
                          minimumSize: const Size(24, 24),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${product.price} ${AppLocalizations.of(context)!.translate('currency')}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Mover también _showEditDialog y _showDeleteDialog fuera de la clase
void _showEditDialog(BuildContext context, Product product, ProductBloc bloc) {
  final nameController = TextEditingController(text: product.name);
  final priceController = TextEditingController(text: product.price.toString());
  final stockController = TextEditingController(text: product.stock.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      String? errorMessage;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.translate('edit_product'),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (errorMessage != null) ...[
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('name'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('price'),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(
                        context,
                      )!.translate('quantity'),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  final newPrice = int.tryParse(priceController.text);
                  final newStock = int.tryParse(stockController.text);

                  if (newName.isEmpty) {
                    setState(() {
                      errorMessage = AppLocalizations.of(
                        context,
                      )!.translate('product_name_empty');
                    });
                    return;
                  }

                  if (newPrice == null || newPrice < 1) {
                    setState(() {
                      errorMessage = AppLocalizations.of(
                        context,
                      )!.translate('price_invalid_format');
                    });
                    return;
                  }

                  if (newStock == null || newStock < 1) {
                    setState(() {
                      errorMessage = AppLocalizations.of(
                        context,
                      )!.translate('quantity_invalid_format');
                    });
                    return;
                  }

                  final updatedProduct = product.copyWith(
                    name: newName,
                    price: newPrice,
                    stock: newStock,
                    updatedAt: DateTime.now(),
                  );
                  bloc.add(UpdateProduct(updatedProduct));
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.translate('product_updated_successfully'),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context)!.translate('save')),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showDeleteDialog(
  BuildContext context,
  Product product,
  ProductBloc bloc,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('delete_product')),
        content: Text(
          '${AppLocalizations.of(context)!.translate('confirm_delete')} "${product.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteProduct(product.id!));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.translate('product')} "${product.name}" ${AppLocalizations.of(context)!.translate('deleted_successfully')}',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.translate('delete')),
          ),
        ],
      );
    },
  );
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.translate('search_products'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.dividerColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      onChanged: (value) {
        context.read<ProductBloc>().add(SearchProducts(value));
      },
    );
  }
}
