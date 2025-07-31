import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockito/l10n/app_localizations.dart';
import '../../../../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
                          secondary: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: isDark ? 180 : 0,
                            ),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.elasticOut,
                            builder: (context, rotation, child) {
                              return TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 1.0,
                                  end: isDark ? 1.0 : 0.8,
                                ),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Transform.rotate(
                                      angle: rotation * 3.14159 / 180,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
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
                              isDark
                                  ? AppLocalizations.of(
                                      context,
                                    )!.translate('light_mode')
                                  : AppLocalizations.of(
                                      context,
                                    )!.translate('dark_mode'),
                              key: ValueKey(isDark),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          value: isDark,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (value) {
                            themeModeNotifier.value = value
                                ? ThemeMode.dark
                                : ThemeMode.light;
                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: Text(
                        AppLocalizations.of(context)!.translate('language'),
                      ),
                      trailing: DropdownButton<Locale>(
                        value: localeNotifier.value,
                        onChanged: (Locale? newLocale) {
                          if (newLocale != null) {
                            localeNotifier.value = newLocale;
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: const Locale('en'),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.translate('language_en'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: const Locale('es'),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.translate('language_es'),
                            ),
                          ),
                          DropdownMenuItem(
                            value: const Locale('pt'),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              )!.translate('language_pt'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        AppLocalizations.of(context)!.translate('developed_by'),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: Text(
                        AppLocalizations.of(context)!.translate('logout'),
                      ),
                      onTap: () => SystemNavigator.pop(),
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
