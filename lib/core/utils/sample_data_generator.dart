import '../../features/products/data/models/product_model.dart';

class SampleDataGenerator {
  static List<ProductModel> getSampleProducts() {
    final now = DateTime.now();

    return [
      ProductModel(
        name: 'Laptop HP Pavilion',
        description:
            'Laptop HP Pavilion 15.6" Intel Core i5, 8GB RAM, 512GB SSD',
        price: 899.99,
        stock: 15,
        barcode: '7891234567890',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Mouse Inalámbrico Logitech',
        description:
            'Mouse inalámbrico Logitech M185, 1000 DPI, batería de 12 meses',
        price: 19.99,
        stock: 50,
        barcode: '7891234567891',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Teclado Mecánico RGB',
        description:
            'Teclado mecánico gaming con switches Cherry MX Blue y retroiluminación RGB',
        price: 129.99,
        stock: 25,
        barcode: '7891234567892',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Monitor Samsung 24"',
        description: 'Monitor Samsung 24" Full HD, 75Hz, FreeSync, panel VA',
        price: 199.99,
        stock: 30,
        barcode: '7891234567893',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Auriculares Sony WH-1000XM4',
        description: 'Auriculares inalámbricos con cancelación de ruido activa',
        price: 349.99,
        stock: 12,
        barcode: '7891234567894',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Webcam Logitech C920',
        description: 'Webcam HD 1080p con micrófono integrado y autofocus',
        price: 79.99,
        stock: 40,
        barcode: '7891234567895',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Disco Duro Externo 1TB',
        description:
            'Disco duro externo Seagate 1TB USB 3.0, compatible con PC y Mac',
        price: 59.99,
        stock: 35,
        barcode: '7891234567896',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Cable HDMI 2.0',
        description: 'Cable HDMI 2.0 de alta velocidad, 2 metros, soporte 4K',
        price: 12.99,
        stock: 100,
        barcode: '7891234567897',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Adaptador USB-C a HDMI',
        description:
            'Adaptador USB-C a HDMI para MacBook, iPad y dispositivos USB-C',
        price: 24.99,
        stock: 60,
        barcode: '7891234567898',
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Soporte para Monitor',
        description:
            'Soporte articulado para monitor de 13" a 27", ajustable en altura',
        price: 89.99,
        stock: 20,
        barcode: '7891234567899',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
