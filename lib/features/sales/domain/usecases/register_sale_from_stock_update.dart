import '../entities/sale.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../repositories/sale_repository.dart';

class RegisterSaleFromStockUpdate {
  final ProductRepository productRepository;
  final SaleRepository saleRepository;

  RegisterSaleFromStockUpdate({
    required this.productRepository,
    required this.saleRepository,
  });

  Future<void> call(int productId, int quantitySold) async {
    final product = await productRepository.getProductById(productId);
    if (product == null) {
      throw Exception('Producto no encontrado');
    }

    int newStock = product.stock - quantitySold;
    if (newStock < 0) {
      newStock = 0;
    }

    final sale = Sale(
      productId: productId,
      productName: product.name,
      quantity: quantitySold,
      pricePerUnit: product.price,
      totalAmount: product.price * quantitySold,
      date: DateTime.now(),
    );

    await saleRepository.createSale(sale);

    final updatedProduct = product.copyWith(stock: newStock);
    await productRepository.updateProduct(updatedProduct);
  }
}
