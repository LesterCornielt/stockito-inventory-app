# Funcionalidad de Reportes de Ventas

## Descripción

Se ha implementado un sistema completo de reportes de ventas que permite registrar y visualizar las ventas diarias de productos de manera automática.

## Características Principales

### 1. Registro Automático de Ventas
- Cuando se reduce el stock de un producto (botón "-"), automáticamente se registra una venta
- La venta incluye:
  - ID del producto
  - Nombre del producto
  - Cantidad vendida
  - Precio por unidad
  - Monto total
  - Fecha y hora de la venta

### 2. Página de Reportes
- **Ubicación**: Pestaña "Reportes" en la navegación inferior
- **Funcionalidades**:
  - Visualización de ventas por día
  - Selector de fecha para ver reportes históricos
  - Resumen diario con total de productos vendidos y monto total
  - Lista detallada de productos vendidos con cantidades y montos

### 3. Estructura de Datos
- **Tabla `sales`**: Almacena todas las ventas registradas
- **Campos**:
  - `id`: Identificador único
  - `product_id`: ID del producto vendido
  - `product_name`: Nombre del producto
  - `quantity`: Cantidad vendida
  - `price_per_unit`: Precio por unidad
  - `total_amount`: Monto total de la venta
  - `date`: Fecha y hora de la venta

## Arquitectura Implementada

### Casos de Uso
1. **`GetSalesReport`**: Genera reportes agregados de ventas por día
2. **`RegisterSaleFromStockUpdate`**: Registra ventas automáticamente al reducir stock
3. **`CreateSale`**: Crea registros de ventas individuales
4. **`GetSalesOfDay`**: Obtiene todas las ventas de un día específico

### BLoC (Business Logic Component)
- **`ReportsBloc`**: Maneja el estado y eventos de la página de reportes
- **Eventos**:
  - `LoadDailyReport`: Carga reporte de una fecha específica
  - `LoadTodayReport`: Carga reporte del día actual
- **Estados**:
  - `ReportsLoading`: Estado de carga
  - `ReportsLoaded`: Reporte cargado exitosamente
  - `ReportsEmpty`: No hay ventas para la fecha seleccionada
  - `ReportsError`: Error al cargar reportes

### Entidades y Modelos
- **`Sale`**: Entidad de venta
- **`SaleModel`**: Modelo de datos para persistencia
- **`SalesReport`**: Reporte agregado por producto
- **`DailySalesReport`**: Reporte completo del día

## Flujo de Trabajo

1. **Registro de Venta**:
   - Usuario presiona botón "-" en un producto
   - Se ejecuta `RegisterSaleFromStockUpdate`
   - Se crea registro en tabla `sales`
   - Se actualiza stock del producto
   - Se recarga lista de productos

2. **Visualización de Reportes**:
   - Usuario navega a pestaña "Reportes"
   - Se carga automáticamente reporte del día actual
   - Usuario puede seleccionar otra fecha
   - Se muestran datos agregados y detallados

## Interfaz de Usuario

### Página de Reportes
- **Header**: Selector de fecha y botón de actualización
- **Resumen del día**: Cards con total de productos y monto
- **Lista de productos**: Tabla con detalles de cada producto vendido
- **Estados vacíos**: Mensaje cuando no hay ventas
- **Estados de error**: Manejo de errores con opción de reintentar

### Diseño
- Consistente con el diseño general de la aplicación
- Colores principales: Azul (#1976D2)
- Iconografía clara y descriptiva
- Responsive y accesible

## Beneficios

1. **Automatización**: No requiere entrada manual de ventas
2. **Precisión**: Los datos se registran automáticamente al reducir stock
3. **Histórico**: Permite revisar ventas de días anteriores
4. **Análisis**: Proporciona insights sobre productos más vendidos
5. **Contabilidad**: Facilita el control de ingresos diarios

## Consideraciones Técnicas

- **Base de datos**: SQLite con tabla `sales`
- **Patrón**: Clean Architecture con BLoC
- **Dependencias**: intl para formateo de fechas
- **Inyección de dependencias**: GetIt para gestión de dependencias
- **Estado**: Manejo reactivo con Flutter BLoC

## Próximas Mejoras

1. **Filtros avanzados**: Por rango de fechas, productos específicos
2. **Exportación**: PDF, Excel, CSV
3. **Gráficos**: Visualizaciones de tendencias
4. **Notificaciones**: Alertas de stock bajo
5. **Backup**: Sincronización con servicios en la nube 