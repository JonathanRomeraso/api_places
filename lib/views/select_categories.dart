import 'package:flutter/material.dart';
import 'package:api_places/utils/categories.dart';

void showCategories(
  BuildContext context,
  List<Category> categories,
  String selectedCategory,
  Function(String value) onCategorySelected,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
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
                const Text("Selecciona una categoría",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    controller: scrollController,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3,
                    children: categories.map((category) {
                      return allCategories(
                        context,
                        category.label,
                        category.value,
                        onCategorySelected,
                      );
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
}

Widget allCategories(
  BuildContext context,
  String label,
  String value,
  Function(String) onCategorySelected,
) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      onCategorySelected(value);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            categories
                .firstWhere(
                  (cat) => cat.value == value,
                  orElse: () =>
                      Category(label: '', value: '', icon: Icons.place),
                )
                .icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
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
