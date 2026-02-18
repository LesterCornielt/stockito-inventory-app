/// Helpers específicos para testing de BLoCs
class BlocTestHelpers {
  /// Helper para verificar que un BLoC emite estados en orden
  ///
  /// Ejemplo de uso:
  /// ```dart
  /// blocTest<MyBloc, MyState>(
  ///   'emits [Loading, Loaded] when LoadEvent is added',
  ///   build: () => myBloc,
  ///   act: (bloc) => bloc.add(LoadEvent()),
  ///   expect: () => [LoadingState(), LoadedState()],
  /// );
  /// ```
}

/// Extensión para facilitar la creación de tests de BLoC
extension BlocTestExtensions on Object {
  // Puedes agregar extensiones útiles aquí si es necesario
}
