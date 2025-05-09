import 'dart:async';

import 'package:api_places/api/geoapify.dart';
import 'package:api_places/models/category_model.dart';
import 'package:api_places/utils/categories.dart';
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
          isScrollControlled: true,
          backgroundColor: Colors.white,
          builder: (_) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Lugares Populares Cercanos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: _places.length,
                        itemBuilder: (_, index) {
                          final place = _places[index];
                          final name =
                              place.properties?.name?.isNotEmpty == true
                                  ? place.properties!.name!
                                  : 'Sin nombre';
                          final subtitle = place.properties?.formatted ?? '';
                          final coordinates = place.geometry?.coordinates;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  categoryIcons[_selectedCategory] ??
                                      Icons.place,
                                  color: Colors.deepPurple,
                                ),
                                title: Text(name),
                                subtitle: Text(subtitle),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onTap: () {
                                  Navigator.pop(context);
                                  if (coordinates != null &&
                                      coordinates.length >= 2) {
                                    _goToPlace(coordinates[1], coordinates[0]);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
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
                            children: categories.map((category) {
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
              categoryIcons[value] ?? Icons.category,
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
