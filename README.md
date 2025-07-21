# Stockito (beta)

**Estado actual:** Beta v0.7.0-beta

Stockito es una app de inventario y ventas desarrollada en Flutter, pensada para pequeños negocios y emprendedores. Actualmente se encuentra en fase beta.

## Funcionalidades actuales

- **Gestión de productos**
  - Alta, edición y eliminación de productos
  - Búsqueda de productos por nombre
  - Visualización de lista de productos con stock y precio
  - Poblado de datos de ejemplo para pruebas rápidas

- **Registro y control de ventas**
  - Registro automático de ventas al reducir el stock de un producto (botón "-")
  - Cada venta almacena: producto, cantidad, precio unitario, monto total, fecha y hora

- **Reportes de ventas**
  - Página dedicada a reportes (pestaña "Reportes")
  - Visualización de ventas por día
  - Selector de fecha para consultar reportes históricos
  - Resumen diario: total de productos vendidos y monto total
  - Lista detallada de productos vendidos con cantidades y montos
  - Estados vacíos y manejo de errores

- **Persistencia y experiencia de usuario**
  - Base de datos local SQLite
  - Navegación y estado persistente entre sesiones
  - Interfaz moderna y responsiva

- **Arquitectura**
  - Clean Architecture
  - Gestión de estado con BLoC
  - Inyección de dependencias con GetIt

- **Próximos pasos**
  - Eliminación completa de Stateful Widgets en toda la app
  - Implementacion de las vistas de Listas y Opciones con su funcionalidad antes de lanzar la v1.0.0
  - Gráficos y visualizaciones

## ¿Cómo contribuir?

¡Las contribuciones son bienvenidas! Para colaborar:

1. Haz un fork del repositorio y clónalo localmente.
2. Crea una rama para tu feature o fix:
   ```sh
   git checkout -b mi-feature
   ```
3. Realiza tus cambios y haz commits descriptivos.
4. Asegúrate de que la app compile y siga las buenas practicas actuales del proyecto
5. Haz push a tu fork y abre un Pull Request hacia `main`.
6. Describe claramente tu aporte en el PR.

**Recomendaciones:**
- Sigue la arquitectura y patrones existentes (Clean Architecture, BLoC, etc).
- Si tienes dudas, abre un issue para discutir tu propuesta antes de implementarla.
- ¡No olvides actualizar el README si agregas una funcionalidad relevante!

---

Licencia: MIT
La licencia MIT es una licencia de software de código abierto permisiva. Esto significa que puedes usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar y/o vender copias del software libremente, siempre y cuando incluyas el aviso de copyright y la declaración de la licencia en todas las copias o partes sustanciales del software. No ofrece garantías, por lo que el uso es bajo tu propio riesgo.

