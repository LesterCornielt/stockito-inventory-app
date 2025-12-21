# 🧪 Cómo Ejecutar los Tests

## 📋 Prerequisitos

1. **Instalar dependencias** (primera vez):
   ```bash
   flutter pub get
   ```

2. **Generar mocks** (solo si usas mockito):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

---

## 🚀 Comandos Principales

### 1. Ejecutar TODOS los tests
```bash
flutter test
```

**Salida esperada:**
```
00:02 +5: All tests passed!
```

---

### 2. Ejecutar tests con COBERTURA
```bash
flutter test --coverage
```

Esto genera el archivo `coverage/lcov.info` que puedes visualizar.

---

### 3. Ejecutar un TEST ESPECÍFICO

**Test de una entidad:**
```bash
flutter test test/unit/features/products/domain/entities/product_test.dart
```

**Todos los tests de productos:**
```bash
flutter test test/unit/features/products/
```

**Solo tests unitarios:**
```bash
flutter test test/unit/
```

**Solo tests de widgets:**
```bash
flutter test test/widget/
```

---

### 4. Ver COBERTURA en HTML

Después de ejecutar `flutter test --coverage`:

```bash
# Instalar lcov (si no lo tienes)
# Ubuntu/Debian:
sudo apt-get install lcov

# macOS:
brew install lcov

# Generar HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir en navegador
open coverage/html/index.html        # macOS
xdg-open coverage/html/index.html    # Linux
start coverage/html/index.html       # Windows
```

---

### 5. MODO WATCH (desarrollo)

Ejecuta tests automáticamente cuando cambias archivos:

```bash
flutter test --watch
```

Presiona `q` para salir.

---

### 6. Tests con VERBOSIDAD

Ver más detalles sobre qué se está ejecutando:

```bash
flutter test --reporter expanded
```

---

### 7. Ejecutar tests en PARALELO

Flutter ejecuta tests en paralelo por defecto, pero puedes controlarlo:

```bash
flutter test --concurrency=4  # Máximo 4 tests simultáneos
```

---

## 📊 Ejemplos de Salida

### Test exitoso:
```
00:01 +1: Product Entity should be a subclass of Equatable
00:01 +2: Product Entity should support value equality
00:01 +3: Product Entity should return correct props
00:01 +4: Product Entity copyWith should return a new instance
00:01 +5: Product Entity copyWith should keep original values

00:02 +5: All tests passed!
```

### Test fallido:
```
00:01 +0 -1: Product Entity should support value equality
Expected: <Product(id: 1, name: 'Test Product', ...)>
  Actual: <Product(id: 1, name: 'Test Product', ...)>

00:01 +0 -1: Some tests failed.
```

---

## 🔍 Troubleshooting

### Error: "Target of URI doesn't exist"
- Verifica que hayas ejecutado `flutter pub get`
- Revisa que los imports relativos sean correctos

### Error: "Database locked" o problemas con SQLite
- Asegúrate de que `TestHelpers.initSqfliteFfi()` se ejecute en `setup_test.dart`
- Verifica que estés cerrando la BD en `tearDown()`

### Tests muy lentos
- Usa `--concurrency` para ajustar paralelismo
- Verifica que no estés usando mocks pesados innecesariamente

---

## 💡 Tips

1. **Ejecuta tests frecuentemente** mientras desarrollas
2. **Usa `--watch`** durante desarrollo activo
3. **Revisa cobertura regularmente** para identificar áreas sin tests
4. **Ejecuta todos los tests antes de hacer commit**

---

## 📝 Ejemplo Completo de Flujo

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Ejecutar todos los tests
flutter test

# 3. Ejecutar con cobertura
flutter test --coverage

# 4. Ver cobertura
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# 5. Ejecutar test específico mientras desarrollas
flutter test test/unit/features/products/domain/entities/product_test.dart
```

---

## 🎯 Comandos Útiles Adicionales

```bash
# Solo mostrar tests que fallan
flutter test --reporter expanded | grep -A 5 "FAILED"

# Ejecutar tests y mostrar tiempo de ejecución
flutter test --reporter json | jq '.duration'

# Saltar tests marcados como "skip"
flutter test --skip-tags slow

# Ejecutar solo tests marcados con cierto tag
flutter test --tags unit
```
