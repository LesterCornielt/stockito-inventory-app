import '../entities/sale.dart';
import '../repositories/product_repository.dart';
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

    // Verificar que hay suficiente stock
    if (product.stock < quantitySold) {
      throw Exception('Stock insuficiente');
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
    final updatedProduct = product.copyWith(
      stock: product.stock - quantitySold,
    );
    await productRepository.updateProduct(updatedProduct);
  }
}
