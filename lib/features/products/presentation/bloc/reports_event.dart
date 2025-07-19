import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyReport extends ReportsEvent {
  final DateTime date;

  const LoadDailyReport(this.date);

  @override
  List<Object?> get props => [date];
}

class LoadTodayReport extends ReportsEvent {
  const LoadTodayReport();
}

class EditSale extends ReportsEvent {
  final int saleId;
  final int newQuantity;

  const EditSale({required this.saleId, required this.newQuantity});

  @override
  List<Object?> get props => [saleId, newQuantity];
}

class EditProductSales extends ReportsEvent {
  final String productName;
  final int newQuantity;

  const EditProductSales({
    required this.productName,
    required this.newQuantity,
  });

  @override
  List<Object?> get props => [productName, newQuantity];
}
