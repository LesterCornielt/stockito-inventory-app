import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_sales_report.dart';

abstract class ReportsState extends Equatable {
  final int? editingIndex;
  final String? editingField;

  const ReportsState({this.editingIndex, this.editingField});

  @override
  List<Object?> get props => [editingIndex, editingField];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial({super.editingIndex, super.editingField});
}

class ReportsLoading extends ReportsState {
  const ReportsLoading({super.editingIndex, super.editingField});
}

class ReportsLoaded extends ReportsState {
  final DailySalesReport report;

  const ReportsLoaded(this.report, {super.editingIndex, super.editingField});

  @override
  List<Object?> get props => [report, editingIndex, editingField];
}

class ReportsEmpty extends ReportsState {
  final DateTime date;

  const ReportsEmpty(this.date, {super.editingIndex, super.editingField});

  @override
  List<Object?> get props => [date, editingIndex, editingField];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message, {super.editingIndex, super.editingField});

  @override
  List<Object?> get props => [message, editingIndex, editingField];
}

class ReportsEditing extends ReportsState {
  final DailySalesReport report;

  const ReportsEditing(this.report, {super.editingIndex, super.editingField});

  @override
  List<Object?> get props => [report, editingIndex, editingField];
}
