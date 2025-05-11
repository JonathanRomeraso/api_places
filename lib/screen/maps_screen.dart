import 'dart:async';
import 'package:api_places/views/select_categories.dart';
import 'package:api_places/views/icon_map.dart';
import 'package:api_places/views/places_found.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:api_places/api/geoapify.dart';
import 'package:api_places/models/category_model.dart';
import 'package:api_places/utils/categories.dart';
import 'package:api_places/views/permiso_denegado.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _posicion;
  bool _permissionDenied = false;
  List<CategoryModel> _places = [];
  String _selectedCategory = "healthcare";
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  MapType mapType = MapType.hybrid;
  LatLng? puntoSeleccionado;

  @override
  void initState() {
    super.initState();
    _permisos();
  }

  void _seleccionar(LatLng position) {
    setState(() {
      puntoSeleccionado = position;
    });
  }

  Future<void> _customIcon() async {
    customIcon = await iconMap(
      categories
          .firstWhere(
            (cat) => cat.value == _selectedCategory,
            orElse: () => Category(label: '', value: '', icon: Icons.place),
          )
          .icon,
      Colors.deepPurpleAccent[400]!,
      30,
    );
  }

  Future<void> _permisos() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      try {
        Position posicion = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _posicion = LatLng(posicion.latitude, posicion.longitude);
        });
        final controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _posicion!, zoom: 15),
        ));
      } catch (e) {
        setState(() => _permissionDenied = true);
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      setState(() => _permissionDenied = true);
    }
  }

  Future<void> _geoApify() async {
    try {
      final api = PopularApi();
      final lat = puntoSeleccionado?.latitude ?? _posicion!.latitude;
      final long = puntoSeleccionado?.longitude ?? _posicion!.longitude;

      final results =
          await api.getGeoApify(_selectedCategory, lat: long, long: lat);
      final label = categories
          .firstWhere(
            (cat) => cat.value == _selectedCategory,
            orElse: () => Category(
              label: 'Desconocido',
              value: '',
              icon: Icons.place,
            ),
          )
          .label;
      if (results != null) {
        await _customIcon();
        setState(() => _places = results);
        placesFound(context, _places, _selectedCategory, _goPlace, label);
      }
    } catch (e) {
      showTopSnackBar(
        animationDuration: Duration(milliseconds: 200),
        reverseAnimationDuration: Duration(milliseconds: 200),
        displayDuration: Duration(seconds: 1),
        Overlay.of(context),
        CustomSnackBar.info(
          message: "No se encontraron lugares populares cercanos",
        ),
      );
      /*
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      */
    }
  }

  Future<void> _goPlace(double lat, double lng) async {
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 17),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return perimisoDenegado();
    return Scaffold(
      body: _posicion == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: mapType,
              zoomControlsEnabled: false,
              compassEnabled: false,
              onTap: _seleccionar,
              initialCameraPosition:
                  CameraPosition(target: _posicion!, zoom: 17),
              myLocationEnabled: true,
              onMapCreated: (controller) => _controller.complete(controller),
              markers: {
                  ..._places.map((place) {
                    return Marker(
                      markerId: MarkerId(place.properties?.placeId ?? ''),
                      position: LatLng(
                        place.geometry!.coordinates![1],
                        place.geometry!.coordinates![0],
                      ),
                      infoWindow: InfoWindow(
                        title: place.properties?.name?.isNotEmpty == true
                            ? place.properties!.name!
                            : 'Sin nombre',
                        snippet: [
                          place.properties?.street,
                          place.properties?.suburb,
                        ].where((element) => element != null).join(", "),
                      ),
                      icon: customIcon,
                    );
                  }),
                  if (puntoSeleccionado != null)
                    Marker(
                      markerId: const MarkerId("selected_location"),
                      position: puntoSeleccionado!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet),
                      infoWindow:
                          const InfoWindow(title: "Ubicación seleccionada"),
                    ),
                }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showCategories(context, categories, _selectedCategory, (value) async {
            setState(() => _selectedCategory = value);
            _geoApify();
          });
        },
        icon: const Icon(Icons.category, color: Colors.white),
        label: const Text("Buscar Categoría",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.deepPurple.shade500,
      ),
      appBar: AppBar(
        title: const Text("Geoapify",
            style: TextStyle(fontSize: 20, color: Colors.white)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple.shade500,
        actions: [
          IconButton(
            icon: const Icon(Icons.map_rounded, color: Colors.white),
            tooltip: "Tipo de Mapa",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                    title: const Text(
                      "Tipo de Mapa",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.map_outlined,
                              color: Colors.deepPurple),
                          title: const Text("Normal"),
                          onTap: () {
                            setState(() => mapType = MapType.normal);
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.satellite_alt_rounded,
                              color: Colors.deepPurple),
                          title: const Text("Satélite"),
                          onTap: () {
                            setState(() => mapType = MapType.satellite);
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.layers_rounded,
                              color: Colors.deepPurple),
                          title: const Text("Híbrido"),
                          onTap: () {
                            setState(() => mapType = MapType.hybrid);
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.terrain,
                              color: Colors.deepPurple),
                          title: const Text("Terreno"),
                          onTap: () {
                            setState(() => mapType = MapType.terrain);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Cerrar",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
