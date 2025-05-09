import 'dart:async';

import 'package:api_places/api/geoapify.dart';
import 'package:api_places/models/category_model.dart';
import 'package:api_places/views/category_selector.dart';
import 'package:api_places/views/permiso_denegado.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _currentPosition;
  bool _permissionDenied = false;
  List<CategoryModel> _places = [];
  String _selectedCategory = "healthcare";

  @override
  void initState() {
    super.initState();
    _permisosLocalizacion();
  }

  Future<void> _permisosLocalizacion() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position posicion = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = LatLng(posicion.latitude, posicion.longitude);
        });

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 15),
        ));
      } catch (e) {
        debugPrint("Error al obtener la ubicación");
        setState(() {
          _permissionDenied = true;
        });
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      setState(() {
        _permissionDenied = true;
      });
    }
  }

  Future<void> _geoApify() async {
    try {
      final api = PopularApi();
      final results = await api.getGeoApify(_selectedCategory);
      if (results != null) {
        setState(() {
          _places = results;
        });
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          backgroundColor: Colors.white,
          isScrollControlled: true,
          builder: (context) {
            return CategorySelector(
              categories: _categories,
              categoryIcons: _categoryIcons,
              onCategorySelected: (value) {
                setState(() {
                  _selectedCategory = value;
                });
                _geoApify();
              },
            );
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _goToPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 17),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return perimisoDenegado();
    }
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _places.map((place) {
                return Marker(
                  markerId: MarkerId(place.properties!.placeId ?? ''),
                  position: LatLng(place.geometry!.coordinates![1],
                      place.geometry!.coordinates![0]),
                  infoWindow: InfoWindow(title: place.properties!.name),
                );
              }).toSet(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (context) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Selecciona una categoría",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Expanded(
                          child: GridView.count(
                            controller: scrollController,
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3,
                            children: _categories.map((category) {
                              return _buildCategoryTile(
                                  category['label']!, category['value']!);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        icon: Icon(Icons.category, color: Colors.white),
        label: Text("Buscar Categoría",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.deepPurple.shade500,
      ),
    );
  }

  final List<Map<String, String>> _categories = [
    {'label': 'Salud', 'value': 'healthcare'},
    {'label': 'Alojamiento', 'value': 'accommodation'},
    {'label': 'Actividades', 'value': 'activity'},
    {'label': 'Aeropuertos', 'value': 'airport'},
    {'label': 'Restaurantes', 'value': 'catering.restaurant'},
    {'label': 'Comida Rapida', 'value': 'catering.fast_food'},
    {'label': 'Educación', 'value': 'education'},
    {'label': 'Infantil', 'value': 'childcare'},
    {'label': 'Entretenimiento', 'value': 'entertainment'},
    {'label': 'Carreteras', 'value': 'highway'},
    {'label': 'Ocio', 'value': 'leisure'},
    {'label': 'Hecho por el Hombre', 'value': 'man_made'},
    {'label': 'Natural', 'value': 'natural'},
    {'label': 'Oficina', 'value': 'office'},
    {'label': 'Estacionamiento', 'value': 'parking'},
    {'label': 'Mascotas', 'value': 'pet'},
    {'label': 'Energía', 'value': 'power'},
    {'label': 'Producción', 'value': 'production'},
    {'label': 'Ferrocarril', 'value': 'railway'},
    {'label': 'Alquiler', 'value': 'rental'},
    {'label': 'Servicio', 'value': 'service'},
    {'label': 'Turismo', 'value': 'tourism'},
    {'label': 'Religión', 'value': 'religion'},
    {'label': 'Camping', 'value': 'camping'},
    {'label': 'Amenidad', 'value': 'amenity'},
    {'label': 'Playa', 'value': 'beach'},
    {'label': 'Adulto', 'value': 'adult'},
    {'label': 'Edificio', 'value': 'building'},
    {'label': 'Deportivo', 'value': 'sport'},
    {'label': 'Transporte Publico', 'value': 'public_transport'},
  ];

  final Map<String, IconData> _categoryIcons = {
    'healthcare': Icons.local_hospital,
    'accommodation': Icons.hotel,
    'activity': Icons.directions_run,
    'airport': Icons.flight,
    'catering.restaurant': Icons.restaurant,
    'catering.fast_food': Icons.fastfood,
    'education': Icons.school,
    'childcare': Icons.child_friendly,
    'entertainment': Icons.movie,
    'highway': Icons.directions_car_filled,
    'leisure': Icons.pool,
    'man_made': Icons.handyman_outlined,
    'natural': Icons.park,
    'office': Icons.business,
    'parking': Icons.local_parking,
    'pet': Icons.pets,
    'power': Icons.bolt,
    'production': Icons.factory,
    'railway': Icons.train,
    'rental': Icons.place,
    'service': Icons.room_service,
    'tourism': Icons.camera_alt,
    'religion': Icons.church,
    'camping': Icons.terrain,
    'amenity': Icons.local_cafe,
    'beach': Icons.beach_access,
    'adult': Icons.explicit,
    'building': Icons.location_city,
    'sport': Icons.sports_soccer,
    'public_transport': Icons.directions_bus,
  };

  Widget _buildCategoryTile(String label, String value) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _selectedCategory = value;
        });
        _geoApify();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _categoryIcons[value] ?? Icons.category,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
