import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_sales_report.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final DailySalesReport report;

  const ReportsLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportsEmpty extends ReportsState {
  final DateTime date;

  const ReportsEmpty(this.date);

  @override
  List<Object?> get props => [date];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message);

  @override
  List<Object?> get props => [message];
}
