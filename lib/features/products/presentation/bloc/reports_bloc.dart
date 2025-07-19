import 'package:flutter_bloc/flutter_bloc.dart';
import 'reports_event.dart';
import 'reports_state.dart';
import '../../domain/usecases/get_sales_report.dart';

// BLoC
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetSalesReport getSalesReport;

  ReportsBloc({required this.getSalesReport}) : super(ReportsInitial()) {
    on<LoadDailyReport>(_onLoadDailyReport);
    on<LoadTodayReport>(_onLoadTodayReport);
  }

  Future<void> _onLoadDailyReport(
    LoadDailyReport event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading());
    try {
      final report = await getSalesReport(event.date);
      if (report.productReports.isEmpty) {
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
}
