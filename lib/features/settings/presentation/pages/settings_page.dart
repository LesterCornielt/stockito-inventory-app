import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.info_outline), title: Text('Acerca de')),
          ListTile(leading: Icon(Icons.logout), title: Text('Cerrar sesión')),
        ],
      ),
    );
  }
}
