import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markers = {};

  Future<void> _onMapTapped(LatLng position) async {
    print("Mapa presionado en: ${position.latitude}, ${position.longitude}");

    // 👉 Reemplaza TU_API_KEY con tu API Key de Geoapify
    final apiKey = '';
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['features'] != null && data['features'].length > 0) {
        final properties = data['features'][0]['properties'];
        final address = properties['formatted'];

        print("Dirección encontrada: $address");

        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(position.toString()),
              position: position,
              infoWindow: InfoWindow(title: address),
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dirección: $address')),
        );
      } else {
        print("No se encontró dirección.");
      }
    } else {
      print("Error al consultar Geoapify: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: _onMapTapped, // 👈 Aquí escuchamos el tap
        markers: _markers,
      ),
    );
  }
}
