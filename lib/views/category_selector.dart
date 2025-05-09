import 'package:flutter/material.dart';

typedef CategoryCallback = void Function(String value);

class CategorySelector extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Map<String, IconData> categoryIcons;
  final CategoryCallback onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.categoryIcons,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Selecciona una categoría",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.count(
                  controller: scrollController,
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3,
                  children: categories.map((category) {
                    return _buildCategoryTile(
                      context,
                      category['label']!,
                      category['value']!,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTile(BuildContext context, String label, String value) {
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
              categoryIcons[value] ?? Icons.category,
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
}
