import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stockito/l10n/app_localizations.dart';

/// Helper class for widget tests
class WidgetTestHelpers {
  /// Creates a MaterialApp with localization support for testing
  static Widget createTestApp({
    required Widget child,
    Locale locale = const Locale('en'),
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MaterialApp(
      locale: locale,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('pt'),
      ],
      home: Scaffold(body: child),
    );
  }
}

