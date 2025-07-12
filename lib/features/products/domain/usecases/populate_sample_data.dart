import 'package:equatable/equatable.dart';
import '../repositories/product_repository.dart';

class PopulateSampleData {
  final ProductRepository repository;

  PopulateSampleData(this.repository);

  Future<void> call() async {
    await repository.populateWithSampleData();
  }
}
