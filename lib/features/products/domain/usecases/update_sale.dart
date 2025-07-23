import '../repositories/sale_repository.dart';
import '../repositories/product_repository.dart';

class UpdateSale {
  final SaleRepository saleRepository;
  final ProductRepository productRepository;

  UpdateSale({required this.saleRepository, required this.productRepository});

  Future<void> call(int saleId, int newQuantity) async {
    // Obtener la venta actual
    final sale = await saleRepository.getSaleById(saleId);

    if (sale == null) {
      throw Exception('Venta no encontrada');
    }

    // Obtener el producto
    final product = await productRepository.getProductById(sale.productId);
    if (product == null) {
      throw Exception('Producto no encontrado');
    }

    // Calcular la diferencia en cantidad
    final quantityDifference = newQuantity - sale.quantity;

    // Si la nueva cantidad es 0, eliminar la venta
    if (newQuantity == 0) {
      await saleRepository.deleteSale(saleId);
      // Restaurar el stock original
      final updatedProduct = product.copyWith(
        stock: product.stock + sale.quantity,
      );
      await productRepository.updateProduct(updatedProduct);
      return;
    }

    // Permitir aumentar la cantidad aunque no haya suficiente stock, pero el stock nunca debe ser negativo
    int newStock = product.stock - quantityDifference;
    if (newStock < 0) {
      newStock = 0;
    }

    // Actualizar la venta
    final updatedSale = sale.copyWith(
      quantity: newQuantity,
      totalAmount: sale.pricePerUnit * newQuantity,
    );
    await saleRepository.updateSale(updatedSale);

    // Actualizar el stock del producto
    final updatedProduct = product.copyWith(stock: newStock);
    await productRepository.updateProduct(updatedProduct);
  }
}
