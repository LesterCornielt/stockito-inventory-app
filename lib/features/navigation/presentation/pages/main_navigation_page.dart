import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/navigation_bloc.dart';
import '../bloc/navigation_event.dart';
import '../bloc/navigation_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../products/presentation/pages/product_list_page.dart';
import '../../../products/presentation/pages/reports_page.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_event.dart';
import '../../../products/presentation/bloc/reports_bloc.dart';
import '../../../lists/presentation/pages/lists_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NavigationBloc>()),
        BlocProvider(
          create: (_) => sl<ProductBloc>()
            ..add(const LoadProducts())
            ..add(const LoadSavedSearch()),
        ),
      ],
      child: const _MainNavigationView(),
    );
  }
}

class _MainNavigationView extends StatefulWidget {
  const _MainNavigationView();

  @override
  State<_MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<_MainNavigationView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showAddProductDialog(BuildContext context, ProductBloc productBloc) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Producto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                final name = nameController.text.trim();
                final price = int.tryParse(priceController.text);
                final stock = int.tryParse(stockController.text);

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El nombre del producto no puede estar vacío',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (price == null || price < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'El precio debe ser un número entero válido mayor o igual a 0',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (stock == null || stock < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La cantidad debe ser un número entero mayor o igual a 0',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                productBloc.add(
                  CreateProduct(name: name, price: price, stock: stock),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto añadido exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        // Cargar el estado guardado al inicializar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<NavigationBloc>().add(const LoadSavedNavigation());
        });

        // Sincronizar el PageController con el estado actual
        if (_pageController.hasClients &&
            _pageController.page?.round() != state.currentIndex) {
          _pageController.animateToPage(
            state.currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }

        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<NavigationBloc>().add(NavigationChanged(index));
              if (index == 0) {
                // Limpiar búsqueda al volver a la página de productos
                context.read<ProductBloc>().add(const ClearSearch());
              }
            },
            children: [
              const ProductListPage(),
              BlocProvider(
                create: (_) => sl<ReportsBloc>(),
                child: const ReportsPage(),
              ),
              const ListsPage(),
              const _SettingsPage(),
            ],
          ),
          backgroundColor: Colors.white,
          floatingActionButton: state.currentIndex == 0
              ? PhysicalModel(
                  color: Colors.transparent,
                  elevation: 12,
                  shadowColor: Colors.black26,
                  shape: BoxShape.circle,
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: FloatingActionButton(
                      onPressed: () => _showAddProductDialog(
                        context,
                        context.read<ProductBloc>(),
                      ),
                      backgroundColor: const Color(0xFF1976D2),
                      shape: const CircleBorder(),
                      elevation: 0,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                )
              : null,
          bottomNavigationBar: _CustomBottomNavBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationChanged(index));
              if (index == 0) {
                // Limpiar búsqueda al volver a la página de productos
                context.read<ProductBloc>().add(const ClearSearch());
              }
            },
          ),
        );
      },
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _CustomBottomNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavBarItemData(Icons.inventory, 'Productos'),
    _NavBarItemData(Icons.analytics, 'Ventas'),
    _NavBarItemData(Icons.list, 'Listas'),
    _NavBarItemData(Icons.settings, 'Opciones'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 32,
      ), // Más separación inferior
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 12,
        borderRadius: BorderRadius.circular(32),
        shadowColor: Colors.black12,
        child: Container(
          height: 72, // Un poco más alto para mejor centrado
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center, // Centrado vertical
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(32),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 6,
                    ), // Centrado
                    decoration: isSelected
                        ? BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(24),
                          )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final String label;
  const _NavBarItemData(this.icon, this.label);
}

// Placeholder pages - these will be implemented later

class _SettingsPage extends StatelessWidget {
  const _SettingsPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.settings, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Pendiente a desarrollar',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
