# Plan de Pruebas Automatizadas - Stockito

## 📋 Overview

Este documento describe la estrategia completa para implementar pruebas automatizadas en la aplicación Stockito, siguiendo las mejores prácticas de Flutter y aprovechando la arquitectura Clean Architecture existente.

---

## 🎯 Objetivos

1. **Cobertura de código**: Alcanzar al menos 80% de cobertura en las capas críticas (domain y data)
2. **Calidad**: Detectar bugs antes de llegar a producción
3. **Mantenibilidad**: Facilitar refactorizaciones futuras con confianza
4. **Documentación viva**: Los tests sirven como documentación del comportamiento esperado

---

## 🏗️ Tipos de Pruebas

### 1. **Unit Tests** (Pruebas Unitarias)
- **Objetivo**: Probar lógica de negocio aislada
- **Cobertura**: Use cases, BLoCs, utilidades, servicios
- **Herramientas**: `flutter_test` (incluido en Flutter SDK)
- **Ubicación**: `test/unit/`

### 2. **Widget Tests** (Pruebas de Widgets)
- **Objetivo**: Probar componentes UI y su interacción con BLoC
- **Cobertura**: Páginas, widgets personalizados, navegación
- **Herramientas**: `flutter_test` + `bloc_test`
- **Ubicación**: `test/widget/`

### 3. **Integration Tests** (Pruebas de Integración)
- **Objetivo**: Probar flujos completos de usuario end-to-end
- **Cobertura**: Flujos críticos (crear producto, registrar venta, generar reporte)
- **Herramientas**: `integration_test` (incluido en Flutter SDK)
- **Ubicación**: `integration_test/`

---

## 📦 Dependencias Necesarias

Agregar al `pubspec.yaml` en `dev_dependencies`:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  bloc_test: ^9.1.5          # Para testear BLoCs
  mockito: ^5.4.4            # Para crear mocks
  build_runner: ^2.4.7       # Para generar código de mocks
  fake_async: ^1.3.1         # Para controlar tiempo en tests
  mocktail: ^1.0.1           # Alternativa moderna a mockito (opcional)
```

---

## 📁 Estructura de Carpetas de Tests

```
test/
├── unit/
│   ├── core/
│   │   ├── database/
│   │   │   └── database_service_test.dart
│   │   ├── di/
│   │   │   └── injection_container_test.dart
│   │   └── utils/
│   │       └── persistence_service_test.dart
│   └── features/
│       ├── products/
│       │   ├── domain/
│       │   │   ├── usecases/
│       │   │   │   ├── create_product_test.dart
│       │   │   │   ├── delete_product_test.dart
│       │   │   │   ├── get_all_products_test.dart
│       │   │   │   ├── search_products_test.dart
│       │   │   │   └── update_product_test.dart
│       │   │   └── entities/
│       │   │       └── product_test.dart
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── product_local_datasource_test.dart
│       │   │   ├── models/
│       │   │   │   └── product_model_test.dart
│       │   │   └── repositories/
│       │   │       └── product_repository_impl_test.dart
│       │   └── presentation/
│       │       └── bloc/
│       │           └── product_bloc_test.dart
│       └── sales/
│           └── [estructura similar a products]
│
├── widget/
│   └── features/
│       ├── products/
│       │   └── presentation/
│       │       └── pages/
│       │           └── product_list_page_test.dart
│       ├── sales/
│       │   └── presentation/
│       │       └── pages/
│       │           └── sales_page_test.dart
│       ├── navigation/
│       │   └── presentation/
│       │       └── pages/
│       │           └── main_navigation_page_test.dart
│       └── settings/
│           └── presentation/
│               └── pages/
│                   └── settings_page_test.dart
│
├── helpers/
│   ├── test_helpers.dart          # Funciones auxiliares para tests
│   ├── mock_data.dart             # Datos de prueba reutilizables
│   └── bloc_test_helpers.dart     # Helpers específicos para BLoC
│
└── mocks/
    └── [archivos generados por build_runner]

integration_test/
├── flows/
│   ├── product_management_flow_test.dart
│   ├── sale_registration_flow_test.dart
│   └── reports_flow_test.dart
└── app_test.dart                  # Test general de la app
```

---

## 🧪 Estrategia por Capa

### **1. Domain Layer (Capa de Dominio)**

#### Use Cases
- **Qué probar**:
  - Llamadas correctas al repositorio
  - Manejo de errores
  - Validación de parámetros
  - Transformación de datos

- **Ejemplo - `GetAllProducts`**:
  ```dart
  - Debe llamar a repository.getAllProducts()
  - Debe retornar la lista de productos del repositorio
  - Debe propagar errores del repositorio
  ```

#### Entities
- **Qué probar**:
  - Igualdad de objetos (Equatable)
  - Copia de objetos (copyWith)
  - Validación de datos

### **2. Data Layer (Capa de Datos)**

#### Data Sources
- **Qué probar**:
  - Operaciones CRUD en base de datos
  - Manejo de errores de SQLite
  - Transformación entre modelos y entidades
  - Casos edge (datos vacíos, null, etc.)

- **Estrategia**:
  - Usar base de datos en memoria para tests
  - Limpiar datos después de cada test

#### Repositories
- **Qué probar**:
  - Llamadas correctas a data sources
  - Mapeo entre modelos y entidades
  - Manejo de errores
  - Cache (si aplica)

### **3. Presentation Layer (Capa de Presentación)**

#### BLoCs
- **Qué probar**:
  - Transiciones de estado correctas
  - Emisión de estados esperados
  - Manejo de eventos
  - Casos de error
  - Estados de carga

- **Ejemplo - `ProductBloc`**:
  ```dart
  - LoadProducts: debe emitir ProductLoading -> ProductsLoaded
  - CreateProduct: debe emitir estados correctos y agregar producto
  - DeleteProduct: debe eliminar producto y actualizar estado
  - SearchProducts: debe filtrar productos correctamente
  - Errores: debe emitir ProductError con mensaje apropiado
  ```

- **Herramienta**: `bloc_test` para facilitar testing de BLoCs

#### Widgets/Pages
- **Qué probar**:
  - Renderizado correcto según estado
  - Interacción con BLoC (eventos emitidos)
  - Navegación
  - Widgets hijos renderizados
  - Estados vacíos y de error

---

## 🔧 Configuración y Helpers

### Test Helpers (`test/helpers/test_helpers.dart`)

```dart
// Funciones auxiliares para:
- Crear instancias de entidades de prueba
- Configurar GetIt para tests
- Limpiar base de datos de prueba
- Crear mocks comunes
```

### Mock Data (`test/helpers/mock_data.dart`)

```dart
// Datos de prueba reutilizables:
- Productos de ejemplo
- Ventas de ejemplo
- Fechas de prueba
```

### Database Setup para Tests

- Usar `sqflite_common_ffi` para tests en desktop
- O usar base de datos en memoria
- Limpiar después de cada test

---

## 📝 Casos de Prueba Prioritarios

### **Alta Prioridad** (Implementar primero)

1. **Domain Layer**:
   - ✅ Todos los use cases de productos
   - ✅ Todos los use cases de ventas
   - ✅ Validaciones de entidades

2. **Data Layer**:
   - ✅ ProductLocalDataSource (CRUD completo)
   - ✅ SaleLocalDataSource (CRUD completo)
   - ✅ Repositorios (mapeo y manejo de errores)

3. **Presentation Layer**:
   - ✅ ProductBloc (todos los eventos)
   - ✅ ReportsBloc
   - ✅ NavigationBloc

### **Media Prioridad**

4. **Widget Tests**:
   - ✅ ProductListPage
   - ✅ SalesPage
   - ✅ MainNavigationPage

5. **Integration Tests**:
   - ✅ Flujo completo: Crear producto → Registrar venta → Ver reporte

### **Baja Prioridad** (Mejoras futuras)

6. **Tests adicionales**:
   - Tests de internacionalización
   - Tests de tema (dark/light mode)
   - Tests de persistencia de búsqueda
   - Performance tests

---

## 🚀 Plan de Implementación (Fases)

### **Fase 1: Setup y Fundamentos** (Semana 1)
- [ ] Agregar dependencias de testing
- [ ] Configurar estructura de carpetas
- [ ] Crear helpers y mocks base
- [ ] Configurar base de datos para tests
- [ ] Escribir primeros tests de ejemplo

### **Fase 2: Domain Layer** (Semana 2)
- [x] Tests de use cases de productos
- [x] Tests de use cases de ventas
- [x] Tests de entidades
- [x] Alcanzar 90%+ cobertura en domain

### **Fase 3: Data Layer** (Semana 3)
- [ ] Tests de data sources
- [ ] Tests de repositorios
- [ ] Tests de modelos
- [ ] Alcanzar 85%+ cobertura en data

### **Fase 4: Presentation Layer - BLoCs** (Semana 4)
- [ ] Tests de ProductBloc
- [ ] Tests de ReportsBloc
- [ ] Tests de NavigationBloc
- [ ] Tests de SettingsBloc (si aplica)

### **Fase 5: Presentation Layer - Widgets** (Semana 5)
- [ ] Tests de páginas principales
- [ ] Tests de widgets personalizados
- [ ] Tests de navegación

### **Fase 6: Integration Tests** (Semana 6)
- [ ] Flujo de gestión de productos
- [ ] Flujo de registro de ventas
- [ ] Flujo de reportes

### **Fase 7: CI/CD y Documentación** (Semana 7)
- [ ] Configurar CI/CD para ejecutar tests
- [ ] Configurar cobertura de código
- [ ] Documentar cómo ejecutar tests
- [ ] Actualizar README con información de testing

---

## 🛠️ Comandos Útiles

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage

# Ejecutar tests específicos
flutter test test/unit/features/products/domain/usecases/

# Ejecutar integration tests
flutter test integration_test/

# Generar mocks (después de agregar mockito)
flutter pub run build_runner build --delete-conflicting-outputs

# Ver cobertura en HTML
genhtml coverage/lcov.info -o coverage/html
```

---

## 📊 Métricas y Cobertura

### Objetivos de Cobertura

- **Domain Layer**: 90%+
- **Data Layer**: 85%+
- **Presentation Layer (BLoCs)**: 85%+
- **Presentation Layer (Widgets)**: 70%+
- **Overall**: 80%+

### Herramientas de Cobertura

- `flutter test --coverage` genera `coverage/lcov.info`
- Integrar con servicios como Codecov o Coveralls
- Visualizar con `genhtml` o herramientas online

---

## 📚 Recursos y Referencias

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [mockito Package](https://pub.dev/packages/mockito)
- [Testing BLoC in Flutter](https://bloclibrary.dev/#/testing)
- [Clean Architecture Testing Strategy](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/)

---

## ✅ Checklist de Implementación

### Setup
- [ ] Dependencias agregadas a `pubspec.yaml`
- [ ] Estructura de carpetas creada
- [ ] Helpers básicos implementados
- [ ] Configuración de base de datos para tests

### Tests Unitarios
- [ ] Domain: Use cases
- [ ] Domain: Entities
- [ ] Data: Data sources
- [ ] Data: Repositories
- [ ] Data: Models
- [ ] Presentation: BLoCs

### Tests de Widgets
- [ ] Páginas principales
- [ ] Widgets personalizados
- [ ] Navegación

### Tests de Integración
- [ ] Flujos críticos de usuario


## 🎓 Buenas Prácticas

1. **AAA Pattern**: Arrange, Act, Assert en cada test
2. **Nombres descriptivos**: `test('should emit ProductsLoaded when LoadProducts is called')`
3. **Tests aislados**: Cada test debe ser independiente
4. **Mocks apropiados**: Mockear dependencias externas
5. **Casos edge**: Probar casos límite y errores
6. **Mantenibilidad**: Refactorizar tests cuando sea necesario
7. **Velocidad**: Tests deben ejecutarse rápidamente
8. **Determinismo**: Tests deben ser determinísticos (sin aleatoriedad)

---

**Última actualización**: 2024
**Versión del plan**: 1.0.0
