import '../repositories/sale_repository.dart';
import '../../../products/domain/repositories/product_repository.dart';

class SaleNotFoundException implements Exception {}

class ProductNotFoundException implements Exception {}

class UpdateSale {
  final SaleRepository saleRepository;
  final ProductRepository productRepository;

  UpdateSale({required this.saleRepository, required this.productRepository});

  Future<void> call(int saleId, int newQuantity) async {
    final sale = await saleRepository.getSaleById(saleId);

    if (sale == null) {
      throw SaleNotFoundException();
    }

    final product = await productRepository.getProductById(sale.productId);
    if (product == null) {
      throw ProductNotFoundException();
    }

    final quantityDifference = newQuantity - sale.quantity;

    if (newQuantity == 0) {
      await saleRepository.deleteSale(saleId);
      final updatedProduct = product.copyWith(
        stock: product.stock + sale.quantity,
      );
      await productRepository.updateProduct(updatedProduct);
      return;
    }

    int newStock = product.stock - quantityDifference;
    if (newStock < 0) {
      newStock = 0;
    }

    final updatedSale = sale.copyWith(
      quantity: newQuantity,
      totalAmount: sale.pricePerUnit * newQuantity,
    );
    await saleRepository.updateSale(updatedSale);

    final updatedProduct = product.copyWith(stock: newStock);
    await productRepository.updateProduct(updatedProduct);
  }
}
