import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/product_bloc.dart';
import '../../presentation/bloc/product_event.dart';
import '../../presentation/bloc/product_state.dart';
import '../../../../../../core/di/injection_container.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const LoadProducts()),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stockito'),
        backgroundColor: theme.colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Buscador
            _SearchBar(),
            const SizedBox(height: 50),
            const Text(
              'Productos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            // Lista de productos
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay productos registrados',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: state.products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(product.description),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Stock: ${product.stock}'),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
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
                  } else if (state is ProductsEmpty) {
                    return const Center(
                      child: Text(
                        'No hay productos registrados',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _DiamondAddButton(),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Buscar productos',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: (value) {
        context.read<ProductBloc>().add(SearchProducts(value));
      },
    );
  }
}

class _DiamondAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      child: FloatingActionButton(
        shape: const DiamondBorder(),
        onPressed: () {
          // TODO: Implementar navegación a pantalla "Add product"
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}

class DiamondBorder extends ShapeBorder {
  const DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final center = rect.center;
    final width = rect.width;
    final height = rect.height;

    final path = Path();
    path.moveTo(center.dx, center.dy - height / 2); // Top
    path.lineTo(center.dx + width / 2, center.dy); // Right
    path.lineTo(center.dx, center.dy + height / 2); // Bottom
    path.lineTo(center.dx - width / 2, center.dy); // Left
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) => this;

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) => this;
}
