import 'package:flutter/material.dart';
import 'package:api_places/models/category_model.dart';
import 'package:api_places/utils/categories.dart';

typedef GoToPlaceCallback = void Function(double lat, double lng);

void placesFound(BuildContext context, List<CategoryModel> places,
    String selectedCategory, GoToPlaceCallback goToPlace, String label) {
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
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Lugares Cercanos para:  $label',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: (places.isEmpty)
                    ? Center(
                        child: Text(
                          'No se encontraron lugares cercanos para: $label',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        controller: controller,
                        itemCount: places.length,
                        itemBuilder: (_, index) {
                          final place = places[index];
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
                                  categories
                                      .firstWhere(
                                        (cat) => cat.value == selectedCategory,
                                        orElse: () => Category(
                                            label: '',
                                            value: '',
                                            icon: Icons.place),
                                      )
                                      .icon,
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
                                    goToPlace(coordinates[1], coordinates[0]);
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
