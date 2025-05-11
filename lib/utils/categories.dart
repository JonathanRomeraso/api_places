import 'package:flutter/material.dart';

class Category {
  final String label;
  final String value;
  final IconData icon;

  const Category({
    required this.label,
    required this.value,
    required this.icon,
  });
}

const List<Category> categories = [
  Category(label: 'Salud', value: 'healthcare', icon: Icons.local_hospital),
  Category(label: 'Alojamiento', value: 'accommodation', icon: Icons.hotel),
  Category(label: 'Actividades', value: 'activity', icon: Icons.directions_run),
  Category(label: 'Aeropuertos', value: 'airport', icon: Icons.flight),
  Category(
      label: 'Restaurantes',
      value: 'catering.restaurant',
      icon: Icons.restaurant),
  Category(
      label: 'Comida Rápida',
      value: 'catering.fast_food',
      icon: Icons.fastfood),
  Category(label: 'Educación', value: 'education', icon: Icons.school),
  Category(label: 'Infantil', value: 'childcare', icon: Icons.child_friendly),
  Category(label: 'Entretenimiento', value: 'entertainment', icon: Icons.movie),
  Category(
      label: 'Carreteras', value: 'highway', icon: Icons.directions_car_filled),
  Category(label: 'Ocio', value: 'leisure', icon: Icons.pool),
  Category(
      label: 'Hecho por el Hombre',
      value: 'man_made',
      icon: Icons.handyman_outlined),
  Category(label: 'Natural', value: 'natural', icon: Icons.park),
  Category(label: 'Oficina', value: 'office', icon: Icons.business),
  Category(
      label: 'Estacionamiento', value: 'parking', icon: Icons.local_parking),
  Category(label: 'Mascotas', value: 'pet', icon: Icons.pets),
  Category(label: 'Energía', value: 'power', icon: Icons.bolt),
  Category(label: 'Producción', value: 'production', icon: Icons.factory),
  Category(label: 'Ferrocarril', value: 'railway', icon: Icons.train),
  Category(label: 'Alquiler', value: 'rental', icon: Icons.place),
  Category(label: 'Servicio', value: 'service', icon: Icons.room_service),
  Category(label: 'Turismo', value: 'tourism', icon: Icons.camera_alt),
  Category(label: 'Religión', value: 'religion', icon: Icons.church),
  Category(label: 'Camping', value: 'camping', icon: Icons.terrain),
  Category(label: 'Amenidad', value: 'amenity', icon: Icons.local_cafe),
  Category(label: 'Playa', value: 'beach', icon: Icons.beach_access),
  Category(label: 'Adulto', value: 'adult', icon: Icons.explicit),
  Category(label: 'Edificio', value: 'building', icon: Icons.location_city),
  Category(label: 'Deportivo', value: 'sport', icon: Icons.sports_soccer),
  Category(
      label: 'Transporte Público',
      value: 'public_transport',
      icon: Icons.directions_bus),
];
