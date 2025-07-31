import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockito/l10n/app_localizations.dart';
import '../bloc/navigation_bloc.dart';
import '../bloc/navigation_event.dart';
import '../bloc/navigation_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../products/presentation/pages/product_list_page.dart';
import '../../../sales/presentation/pages/sales_page.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_event.dart';
import '../../../sales/presentation/bloc/reports_bloc.dart';
import '../../../your_feature/presentation/pages/your_feature_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<NavigationBloc>()..add(const LoadSavedNavigation()),
        ),
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

class _MainNavigationView extends StatelessWidget {
  const _MainNavigationView();

  void _showAddProductDialog(BuildContext context, ProductBloc productBloc) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorMessage;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.translate('add_product'),
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
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = int.tryParse(priceController.text);
                    final stock = int.tryParse(stockController.text);

                    if (name.isEmpty) {
                      setState(() {
                        errorMessage = AppLocalizations.of(
                          context,
                        )!.translate('product_name_empty');
                      });
                      return;
                    }

                    if (price == null || price < 1) {
                      setState(() {
                        errorMessage = AppLocalizations.of(
                          context,
                        )!.translate('price_invalid');
                      });
                      return;
                    }

                    if (stock == null || stock < 1) {
                      setState(() {
                        errorMessage = AppLocalizations.of(
                          context,
                        )!.translate('quantity_invalid');
                      });
                      return;
                    }

                    productBloc.add(
                      CreateProduct(name: name, price: price, stock: stock),
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(
                            context,
                          )!.translate('product_added_successfully'),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.translate('add')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: state.pageController,
            onPageChanged: (index) {
              context.read<NavigationBloc>().add(PageChanged(index));
              if (index == 0) {
                context.read<ProductBloc>().add(const ClearSearch());
              }
            },
            children: [
              const ProductListPage(),
              BlocProvider(
                create: (_) => sl<ReportsBloc>(),
                child: const SalesPage(),
              ),
              const YourFeaturePage(),
              const SettingsPage(),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
              context.read<NavigationBloc>().add(TabChanged(index));
              if (index == 0) {
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

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavBarItemData(
        Icons.inventory,
        AppLocalizations.of(context)!.translate('products'),
      ),
      _NavBarItemData(
        Icons.analytics,
        AppLocalizations.of(context)!.translate('sales'),
      ),
      _NavBarItemData(
        Icons.list,
        AppLocalizations.of(context)!.translate('your_feature'),
      ),
      _NavBarItemData(
        Icons.settings,
        AppLocalizations.of(context)!.translate('settings'),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 12,
        borderRadius: BorderRadius.circular(32),
        shadowColor: Colors.black12,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(items.length, (index) {
              final item = items[index];
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
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: Theme.of(context).colorScheme.primary
                                .withAlpha((0.18 * 255).toInt()),
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
                            fontSize: 10,
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
