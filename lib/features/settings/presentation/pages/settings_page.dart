import 'package:flutter/material.dart';
import 'package:stockito/l10n/app_localizations.dart';
import '../../../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Primero inicializamos el controlador
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Luego inicializamos todas las animaciones
    _rotationAnimation = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 60.0,
      ),
    ]).animate(_controller);

    // Finalmente, establecemos el valor inicial si es necesario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && themeModeNotifier.value == ThemeMode.dark) {
        _controller.value = 1.0;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate('settings'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeModeNotifier,
                      builder: (context, themeMode, child) {
                        final isDark = themeMode == ThemeMode.dark;
                        return SwitchListTile(
                          secondary: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Transform.rotate(
                                  angle:
                                      _rotationAnimation.value * 3.14159 / 180,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    child: Icon(
                                      Icons.brightness_6,
                                      color: isDark
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          title: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            child: Text(
                              isDark ? 'Modo claro' : 'Modo oscuro',
                              key: ValueKey(isDark),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          value: isDark,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            if (value) {
                              _controller.forward();
                            } else {
                              _controller.reverse();
                            }
                            themeModeNotifier.value = value
                                ? ThemeMode.dark
                                : ThemeMode.light;
                          },
                        );
                      },
                    ),
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Acerca de'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Idioma'),
                      trailing: DropdownButton<Locale>(
                        value: localeNotifier.value,
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            localeNotifier.value = newLocale;
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English'),
                          ),
                          DropdownMenuItem(
                            value: Locale('es'),
                            child: Text('Español'),
                          ),
                          DropdownMenuItem(
                            value: Locale('pt'),
                            child: Text('Português'),
                          ),
                        ],
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
