import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                child: const Text(
                  'Productos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Lista de productos
              Expanded(
                child: FutureBuilder<bool>(
                  future: PersistenceService.getShowSampleDialog(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final showSampleDialog = snapshot.data!;
                    return BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is ProductsLoaded) {
                          return _buildProductList(state.products, context);
                        } else if (state is ProductsEmpty) {
                          if (state.searchQuery != null &&
                              state.searchQuery!.isNotEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No tiene un producto con ese nombre registrado',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          } else if (showSampleDialog) {
                            return _SampleDialogCheckbox(
                              initialValue: showSampleDialog,
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'No hay productos registrados aún',
                                style: TextStyle(fontSize: 16),
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
                    );
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
class _SampleDialogCheckbox extends StatelessWidget {
  final bool initialValue;
  const _SampleDialogCheckbox({Key? key, required this.initialValue})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No hay productos registrados aún',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(const PopulateSampleData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Cargar Productos de Ejemplo'),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: initialValue,
                onChanged: (val) async {
                  if (val == null) return;
                  await PersistenceService.setShowSampleDialog(val);
                  // No es necesario hacer setState ni nada, el cambio se reflejará al reiniciar la app
                },
              ),
              const Text('Mostrar cada vez que inicie la app'),
            ],
          ),
        ],
      ),
    );
  }
}

// Mover esta función fuera de cualquier clase
Widget _buildProductList(List<Product> products, BuildContext context) {
  // Ordenar productos alfabéticamente por nombre (A-Z)
  final sortedProducts = List<Product>.from(products)
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  if (sortedProducts.isEmpty) {
    return const Center(
      child: Text(
        'No hay productos registrados',
        style: TextStyle(fontSize: 16),
      ),
    );
  }
  return ListView.separated(
    itemCount: sortedProducts.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (context, index) {
      final product = sortedProducts[index];
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
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
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Cantidad: ${product.stock}'),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: product.stock > 0
                            ? () {
                                context.read<ProductBloc>().add(
                                  RegisterSale(
                                    productId: product.id!,
                                    quantity: 1,
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        style: IconButton.styleFrom(
                          backgroundColor: product.stock > 0
                              ? Colors.red.shade100
                              : Colors.grey.shade200,
                          foregroundColor: product.stock > 0
                              ? Colors.red.shade700
                              : Colors.grey.shade500,
                          minimumSize: const Size(32, 32),
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
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.green.shade700,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${product.price} CUP',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
            title: const Text('Editar Producto'),
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
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Precio CUP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  final newPrice = int.tryParse(priceController.text);
                  final newStock = int.tryParse(stockController.text);

                  if (newName.isEmpty) {
                    setState(() {
                      errorMessage =
                          'El nombre del producto no puede estar vacío';
                    });
                    return;
                  }

                  if (newPrice == null || newPrice < 1) {
                    setState(() {
                      errorMessage = 'El precio debe ser mayor o igual a 1 CUP';
                    });
                    return;
                  }

                  if (newStock == null || newStock < 1) {
                    setState(() {
                      errorMessage =
                          'La cantidad debe ser mayor o igual a 1 unidad';
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
                    const SnackBar(
                      content: Text('Producto actualizado exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Guardar'),
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
        title: const Text('Eliminar Producto'),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${product.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteProduct(product.id!));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Producto "${product.name}" eliminado exitosamente',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
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
        hintText: 'Buscar productos',
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
