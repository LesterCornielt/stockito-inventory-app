import '../../features/products/data/models/product_model.dart';

class SampleDataGenerator {
  static List<ProductModel> getSampleProducts() {
    final now = DateTime.now();

    return [
      // Cervezas
      ProductModel(
        name: 'Corona Extra 330ml',
        price: 250,
        stock: 48,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Heineken 330ml',
        price: 280,
        stock: 36,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Modelo Especial 355ml',
        price: 230,
        stock: 42,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Budweiser 330ml',
        price: 220,
        stock: 54,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Tecate Light 355ml',
        price: 210,
        stock: 38,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Dos Equis Lager 355ml',
        price: 240,
        stock: 45,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Pacifico Clara 355ml',
        price: 235,
        stock: 40,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Pacifico Oscura 355ml',
        price: 235,
        stock: 35,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Sol 330ml',
        price: 200,
        stock: 50,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Victoria 355ml',
        price: 225,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),

      // Helados
      ProductModel(
        name: 'Helado Vainilla 1L',
        price: 850,
        stock: 15,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Chocolate 1L',
        price: 850,
        stock: 12,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Fresa 1L',
        price: 850,
        stock: 10,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Cookies & Cream 1L',
        price: 900,
        stock: 8,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Menta 1L',
        price: 850,
        stock: 6,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Pistacho 1L',
        price: 950,
        stock: 5,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Caramelo 1L',
        price: 850,
        stock: 7,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Limón 1L',
        price: 800,
        stock: 4,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Café 1L',
        price: 850,
        stock: 6,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Helado Nuez 1L',
        price: 900,
        stock: 5,
        createdAt: now,
        updatedAt: now,
      ),

      // Galletas
      ProductModel(
        name: 'Oreo Original 137g',
        price: 350,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Oreo Chocolate 137g',
        price: 350,
        stock: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Chocolate Chip Cookies 200g',
        price: 400,
        stock: 18,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Ritz Crackers 200g',
        price: 300,
        stock: 22,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Galletas María 200g',
        price: 250,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Animal Crackers 200g',
        price: 280,
        stock: 15,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Principe 200g',
        price: 320,
        stock: 12,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Digestive 200g',
        price: 350,
        stock: 10,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Graham Crackers 200g',
        price: 300,
        stock: 8,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Oatmeal Cookies 200g',
        price: 380,
        stock: 14,
        createdAt: now,
        updatedAt: now,
      ),

      // Refrescos
      ProductModel(
        name: 'Coca Cola 355ml',
        price: 150,
        stock: 60,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Coca Cola Zero 355ml',
        price: 150,
        stock: 45,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Pepsi 355ml',
        price: 140,
        stock: 55,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Pepsi Zero 355ml',
        price: 140,
        stock: 40,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Sprite 355ml',
        price: 130,
        stock: 50,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Fanta Naranja 355ml',
        price: 130,
        stock: 35,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Fanta Uva 355ml',
        price: 130,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: '7UP 355ml',
        price: 130,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Dr Pepper 355ml',
        price: 160,
        stock: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Mountain Dew 355ml',
        price: 150,
        stock: 15,
        createdAt: now,
        updatedAt: now,
      ),

      // Snacks
      ProductModel(
        name: 'Ruffles Original 85g',
        price: 200,
        stock: 40,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Ruffles Queso 85g',
        price: 200,
        stock: 35,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Sabritas Original 85g',
        price: 180,
        stock: 45,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Sabritas Adobadas 85g',
        price: 180,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Doritos Nacho 85g',
        price: 220,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Doritos Flamin Hot 85g',
        price: 220,
        stock: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Cheetos Flamin Hot 85g',
        price: 200,
        stock: 18,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Cheetos Puffs 85g',
        price: 180,
        stock: 22,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Fritos Original 85g',
        price: 160,
        stock: 15,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Takis Fuego 85g',
        price: 250,
        stock: 12,
        createdAt: now,
        updatedAt: now,
      ),

      // Chocolates
      ProductModel(
        name: 'Hershey Chocolate 43g',
        price: 120,
        stock: 35,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Snickers 57g',
        price: 150,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Milky Way 58g',
        price: 130,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Kit Kat 41g',
        price: 140,
        stock: 28,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'M&M Peanut 47g',
        price: 160,
        stock: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'M&M Chocolate 47g',
        price: 160,
        stock: 22,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Reese Peanut Butter 51g',
        price: 170,
        stock: 18,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Twix 57g',
        price: 150,
        stock: 24,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: '3 Musketeers 60g',
        price: 130,
        stock: 16,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Butterfinger 57g',
        price: 160,
        stock: 14,
        createdAt: now,
        updatedAt: now,
      ),

      // Bebidas energéticas
      ProductModel(
        name: 'Red Bull 250ml',
        price: 450,
        stock: 20,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Monster 473ml',
        price: 500,
        stock: 15,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Rockstar 473ml',
        price: 480,
        stock: 12,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Powerade Mango 500ml',
        price: 250,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Gatorade Limón 500ml',
        price: 250,
        stock: 22,
        createdAt: now,
        updatedAt: now,
      ),

      // Agua
      ProductModel(
        name: 'Bonafont 600ml',
        price: 100,
        stock: 80,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Ciel 600ml',
        price: 100,
        stock: 75,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Epura 600ml',
        price: 90,
        stock: 70,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Bonafont 1L',
        price: 150,
        stock: 60,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Ciel 1L',
        price: 150,
        stock: 55,
        createdAt: now,
        updatedAt: now,
      ),

      // Jugos
      ProductModel(
        name: 'Del Valle Naranja 1L',
        price: 280,
        stock: 30,
        createdAt: now,
        updatedAt: now,
      ),
      ProductModel(
        name: 'Del Valle Manzana 1L',
        price: 280,
        stock: 25,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
