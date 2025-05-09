import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Widget perimisoDenegado() {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Permiso de ubicación denegado',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: openAppSettings,
            child: const Text('Abrir configuración'),
          )
        ],
      ),
    ),
  );
}
