import 'package:flutter/material.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pill para el título 'Listas'
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Listas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Contenido principal
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Pendiente a desarrollar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: PhysicalModel(
      //   color: Colors.transparent,
      //   elevation: 12,
      //   shadowColor: Colors.black26,
      //   shape: BoxShape.circle,
      //   child: SizedBox(
      //     width: 72,
      //     height: 72,
      //     child: FloatingActionButton(
      //       onPressed: () {
      //         // TODO: Implementar creación de nueva lista
      //       },
      //       backgroundColor: const Color(0xFF1976D2),
      //       shape: const CircleBorder(),
      //       elevation: 0,
      //       child: const Icon(Icons.add, color: Colors.white, size: 40),
      //     ),
      //   ),
      // ),
    );
  }
}
