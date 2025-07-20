import 'package:get_it/get_it.dart';
import '../database/database_service.dart';
import '../../features/products/data/datasources/product_local_datasource.dart';
import '../../features/products/data/datasources/sale_local_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/data/repositories/sale_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/repositories/sale_repository.dart';
import '../../features/products/domain/usecases/create_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/domain/usecases/search_products.dart';
import '../../features/products/domain/usecases/update_product.dart';
import '../../features/products/domain/usecases/populate_sample_data.dart';
import '../../features/products/domain/usecases/create_sale.dart';
import '../../features/products/domain/usecases/get_sales_of_day.dart';
import '../../features/products/domain/usecases/get_sales_report.dart';
import '../../features/products/domain/usecases/register_sale_from_stock_update.dart';
import '../../features/products/domain/usecases/update_sale.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';
import '../../features/products/presentation/bloc/reports_bloc.dart';
import '../../features/navigation/presentation/bloc/navigation_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database
  await DatabaseService.database; // Inicializar la base de datos

  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getAllProducts: sl(),
      createProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      searchProducts: sl(),
      populateSampleData: sl(),
      registerSaleFromStockUpdate: sl(),
    ),
  );
  sl.registerFactory(() => ReportsBloc(getSalesReport: sl(), updateSale: sl()));
  sl.registerFactory(() => NavigationBloc());

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => CreateProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => PopulateSampleData(sl()));
  sl.registerLazySingleton(() => CreateSale(sl()));
  sl.registerLazySingleton(() => GetSalesOfDay(sl()));
  sl.registerLazySingleton(() => GetSalesReport(sl()));
  sl.registerLazySingleton(
    () => RegisterSaleFromStockUpdate(
      productRepository: sl(),
      saleRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateSale(saleRepository: sl(), productRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SaleRepository>(() => SaleRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SaleLocalDataSource>(
    () => SaleLocalDataSourceImpl(),
  );
}
