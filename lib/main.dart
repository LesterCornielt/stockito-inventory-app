import 'package:flutter/material.dart';
import 'core/di/injection_container.dart' as di;
import 'features/navigation/presentation/pages/main_navigation_page.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Stockito',
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1976D2),
            ),
          ),
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF1976D2),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: mode,
          home: const MainNavigationPage(),
        );
      },
    );
  }
}
