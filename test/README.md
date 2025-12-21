# Tests - Stockito

Esta carpeta contiene todos los tests automatizados del proyecto Stockito.

## Estructura

```
test/
├── unit/              # Tests unitarios (lógica de negocio)
├── widget/            # Tests de widgets y UI
├── helpers/           # Helpers y utilidades para tests
└── mocks/             # Mocks generados (por build_runner)
```

## Configuración Inicial

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Generar mocks** (si usas mockito):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Ejecutar Tests

### Todos los tests
```bash
flutter test
```

### Tests con cobertura
```bash
flutter test --coverage
```

### Tests específicos
```bash
# Tests unitarios de productos
flutter test test/unit/features/products/

# Test específico
flutter test test/unit/features/products/domain/entities/product_test.dart
```

### Ver cobertura en HTML
```bash
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## Helpers Disponibles

### `test/helpers/mock_data.dart`
Datos de prueba reutilizables:
- `MockData.sampleProduct1`, `sampleProduct2`, etc.
- `MockData.sampleSale1`, `sampleSale2`, etc.
- `MockData.createProduct(...)` - Crea productos personalizados
- `MockData.createSale(...)` - Crea ventas personalizadas

### `test/helpers/test_helpers.dart`
Funciones auxiliares:
- `TestHelpers.initTestDatabase()` - Crea BD en memoria para tests
- `TestHelpers.clearTestDatabase(db)` - Limpia la BD
- `TestHelpers.closeTestDatabase(db)` - Cierra la BD
- `TestHelpers.resetGetIt()` - Resetea GetIt
- `TestHelpers.setupGetItWithTestDatabase(db)` - Configura GetIt con BD de prueba

### `test/helpers/bloc_test_helpers.dart`
Helpers específicos para testing de BLoCs.

## Ejemplo de Uso

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockito/test/helpers/mock_data.dart';
import 'package:stockito/test/helpers/test_helpers.dart';

void main() {
  late sqflite.Database testDb;

  setUp(() async {
    testDb = await TestHelpers.initTestDatabase();
  });

  tearDown(() async {
    await TestHelpers.clearTestDatabase(testDb);
    await TestHelpers.closeTestDatabase(testDb);
  });

  test('should create a product', () {
    final product = MockData.sampleProduct1;
    expect(product.name, 'Producto Test 1');
    expect(product.price, 10000);
  });
}
```

## Notas

- Los tests usan `sqflite_common_ffi` para ejecutarse en desktop
- La base de datos de tests se crea en memoria y se limpia después de cada test
- Usa los helpers de `mock_data.dart` para datos consistentes en todos los tests
