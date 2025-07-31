import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stockito/core/utils/persistence_service.dart';
import 'package:stockito/l10n/app_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'features/navigation/presentation/pages/main_navigation_page.dart';

final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.light,
);

final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await PersistenceService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              title: 'Stockito',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF1976D2),
                  primary: const Color(0xFF1976D2),
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF1976D2),
                  primary: const Color(0xFF1976D2),
                  brightness: Brightness.dark,
                ),
              ),
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
                Locale('es', ''),
                Locale('pt', ''),
              ],
              themeMode: mode,
              home: const MainNavigationPage(),
            );
          },
        );
      },
    );
  }
}
