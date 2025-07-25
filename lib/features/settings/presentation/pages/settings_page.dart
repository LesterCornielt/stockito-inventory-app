import 'package:flutter/material.dart';
import '../../../../main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text('Modo oscuro'),
            value: themeModeNotifier.value == ThemeMode.dark,
            onChanged: (value) {
              themeModeNotifier.value = value
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
          ),
          ListTile(leading: Icon(Icons.info_outline), title: Text('Acerca de')),
          ListTile(leading: Icon(Icons.logout), title: Text('Cerrar sesión')),
        ],
      ),
    );
  }
}
