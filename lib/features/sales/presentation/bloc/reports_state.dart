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
  const ReportsInitial({int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);
}

class ReportsLoading extends ReportsState {
  const ReportsLoading({int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);
}

class ReportsLoaded extends ReportsState {
  final DailySalesReport report;

  const ReportsLoaded(this.report, {int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);

  @override
  List<Object?> get props => [report, editingIndex, editingField];
}

class ReportsEmpty extends ReportsState {
  final DateTime date;

  const ReportsEmpty(this.date, {int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);

  @override
  List<Object?> get props => [date, editingIndex, editingField];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError(this.message, {int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);

  @override
  List<Object?> get props => [message, editingIndex, editingField];
}

class ReportsEditing extends ReportsState {
  final DailySalesReport report;

  const ReportsEditing(this.report, {int? editingIndex, String? editingField})
    : super(editingIndex: editingIndex, editingField: editingField);

  @override
  List<Object?> get props => [report, editingIndex, editingField];
}
