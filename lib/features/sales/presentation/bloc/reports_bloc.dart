import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_event.dart';
import 'reports_state.dart';
import '../../domain/usecases/get_sales_report.dart';
import '../../domain/usecases/update_sale.dart';

// BLoC
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetSalesReport getSalesReport;
  final UpdateSale updateSale;

  ReportsBloc({required this.getSalesReport, required this.updateSale})
    : super(ReportsInitial()) {
    on<LoadDailyReport>(_onLoadDailyReport);
    on<LoadTodayReport>(_onLoadTodayReport);
    on<EditSale>(_onEditSale);
    on<EditProductSales>(_onEditProductSales);
  }

  Future<void> _onLoadDailyReport(
    LoadDailyReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final report = await getSalesReport(event.date);
      if (report.individualSales.isEmpty) {
        emit(ReportsEmpty(event.date));
      } else {
        emit(ReportsLoaded(report));
      }
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onLoadTodayReport(
    LoadTodayReport event,
    Emitter<ReportsState> emit,
  ) async {
    final today = DateTime.now();
    add(LoadDailyReport(today));
  }

  Future<void> _onEditSale(EditSale event, Emitter<ReportsState> emit) async {
    try {
      final currentState = state;
      if (currentState is ReportsLoaded) {
        emit(ReportsEditing(currentState.report));

        await updateSale(event.saleId, event.newQuantity);

        // Recargar el reporte actual
        final report = await getSalesReport(currentState.report.date);
        if (report.individualSales.isEmpty) {
          emit(ReportsEmpty(report.date));
        } else {
          emit(ReportsLoaded(report));
        }
      }
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onEditProductSales(
    EditProductSales event,
    Emitter<ReportsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is ReportsLoaded) {
        emit(ReportsEditing(currentState.report));

        // Obtener todas las ventas del día
        final sales = await getSalesReport(currentState.report.date);

        // Encontrar las ventas del producto específico
        final productSales = sales.individualSales
            .where((sale) => sale.productName == event.productName)
            .toList();

        if (productSales.isEmpty) {
          throw Exception('No se encontraron ventas para este producto');
        }

        // Si la nueva cantidad es 0, eliminar todas las ventas del producto
        if (event.newQuantity == 0) {
          for (final sale in productSales) {
            await updateSale(sale.saleId, 0);
          }
        } else {
          // Simplificar: actualizar solo la primera venta con la nueva cantidad total
          // y eliminar las demás
          await updateSale(productSales.first.saleId, event.newQuantity);

          // Eliminar las ventas adicionales si existen
          for (int i = 1; i < productSales.length; i++) {
            await updateSale(productSales[i].saleId, 0);
          }
        }

        // Recargar el reporte actual
        final report = await getSalesReport(currentState.report.date);
        if (report.individualSales.isEmpty) {
          emit(ReportsEmpty(report.date));
        } else {
          emit(ReportsLoaded(report));
        }
      }
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
