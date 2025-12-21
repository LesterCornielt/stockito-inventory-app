import 'helpers/test_helpers.dart';

/// Setup inicial para todos los tests
/// Este archivo se ejecuta antes de todos los tests
void main() {
  // Inicializar sqflite_common_ffi una vez para todos los tests
  TestHelpers.initSqfliteFfi();
}
