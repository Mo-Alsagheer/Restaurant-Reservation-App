import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/models/food_category.dart';
import '../../../../core/data/repositories/food_category_repository.dart';

class FoodCategoryPicker extends ConsumerStatefulWidget {
  final FoodCategory? selectedCategory;
  final ValueChanged<FoodCategory?> onCategorySelected;

  const FoodCategoryPicker({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  ConsumerState<FoodCategoryPicker> createState() => _FoodCategoryPickerState();
}

class _FoodCategoryPickerState extends ConsumerState<FoodCategoryPicker> {
  Future<List<FoodCategory>>? _categoriesFuture;

  @override
  void initState() {
    super.initState();
    // Delay the read until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadCategories();
      }
    });
  }

  void _loadCategories() {
    if (mounted) {
      final repository = ref.read(foodCategoryRepositoryProvider);
      setState(() {
        _categoriesFuture = repository.getAllCategories();
      });
    }
  }

  void _refreshCategories() {
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Food Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () async {
                await context.push('/categories');
                // Refresh categories when returning from management page
                _refreshCategories();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Manage Categories'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<FoodCategory>>(
          future: _categoriesFuture,
          builder: (context, snapshot) {
            // Handle initial null state
            if (_categoriesFuture == null ||
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.error, size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 8),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _refreshCategories,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final categories = snapshot.data ?? [];

            if (categories.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.category, size: 48, color: Colors.grey),
                      const SizedBox(height: 8),
                      const Text('No categories available'),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await context.push('/categories');
                          _refreshCategories();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Category'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return DropdownButtonFormField<FoodCategory>(
              initialValue: widget.selectedCategory,
              decoration: const InputDecoration(
                hintText: 'Select a category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: widget.onCategorySelected,
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }
}

// Provider for the repository
final foodCategoryRepositoryProvider = Provider<FoodCategoryRepository>((ref) {
  return FoodCategoryRepository();
});
