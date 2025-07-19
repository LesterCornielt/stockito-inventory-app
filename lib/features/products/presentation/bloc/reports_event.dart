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
