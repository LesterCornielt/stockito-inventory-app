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
    // Obtener el producto actual
    final product = await productRepository.getProductById(productId);
    if (product == null) {
      throw Exception('Producto no encontrado');
    }

    // Permitir la venta aunque el stock sea insuficiente, pero el stock nunca debe ser negativo
    int newStock = product.stock - quantitySold;
    if (newStock < 0) {
      newStock = 0;
    }

    // Crear la venta
    final sale = Sale(
      productId: productId,
      productName: product.name,
      quantity: quantitySold,
      pricePerUnit: product.price,
      totalAmount: product.price * quantitySold,
      date: DateTime.now(),
    );

    // Registrar la venta
    await saleRepository.createSale(sale);

    // Actualizar el stock del producto
    final updatedProduct = product.copyWith(stock: newStock);
    await productRepository.updateProduct(updatedProduct);
  }
}
