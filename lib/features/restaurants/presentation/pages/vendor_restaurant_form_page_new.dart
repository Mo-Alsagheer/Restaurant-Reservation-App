import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/domain/models/food_category.dart';
import '../../../../core/domain/models/location.dart';
import '../../../../core/domain/models/table_model.dart';
import '../../../../core/domain/models/time_slot.dart';
import '../controllers/restaurant_form_controller.dart';
import '../widgets/food_category_picker.dart';
import '../widgets/time_slot_picker.dart';
import '../widgets/table_configuration.dart';

class VendorRestaurantFormPage extends ConsumerStatefulWidget {
  final String? restaurantId;

  const VendorRestaurantFormPage({super.key, this.restaurantId});

  @override
  ConsumerState<VendorRestaurantFormPage> createState() =>
      _VendorRestaurantFormPageState();
}

class _VendorRestaurantFormPageState
    extends ConsumerState<VendorRestaurantFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  File? _imageFile;
  FoodCategory? _selectedCategory;
  Location? _location;
  List<TimeSlot> _timeSlots = [];
  List<TableModel> _tables = [];

  bool get isEditing => widget.restaurantId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null && mounted) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final controller = ref.read(restaurantFormControllerProvider.notifier);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final location = await controller.getCurrentLocation();

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (location != null) {
        if (mounted) {
          setState(() {
            _location = location;
            _addressController.text = location.address ?? 'Unknown address';
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location obtained successfully')),
          );
        }
      } else {
        if (mounted) {
          final state = ref.read(restaurantFormControllerProvider);
          final errorMessage =
              state.error ??
              'Failed to get location. Please make sure:\n1. Location services are enabled\n2. You have granted location permissions\n3. Your GPS is working';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  Future<void> _saveRestaurant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate all required fields
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a food category')),
      );
      return;
    }

    if (_location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set restaurant location')),
      );
      return;
    }

    if (_timeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one time slot')),
      );
      return;
    }

    if (_tables.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please configure tables')));
      return;
    }

    final controller = ref.read(restaurantFormControllerProvider.notifier);

    final restaurantId = await controller.createRestaurant(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageFile: _imageFile,
      category: _selectedCategory!,
      location: _location!,
      timeSlots: _timeSlots,
      tables: _tables,
    );

    if (mounted) {
      final state = ref.read(restaurantFormControllerProvider);

      if (restaurantId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restaurant created successfully!')),
        );
        context.pop();
        return;
      }

      if (state.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantFormControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Restaurant' : 'Add Restaurant'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image picker
                  _buildImagePicker(),
                  const SizedBox(height: 24),

                  // Basic info
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Restaurant Name *',
                      hintText: 'Enter restaurant name',
                      prefixIcon: Icon(Icons.restaurant),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter restaurant name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Describe your restaurant',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Food category picker
                  FoodCategoryPicker(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      if (mounted) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Location
                  _buildLocationSection(),
                  const SizedBox(height: 24),

                  // Time slots
                  TimeSlotPicker(
                    initialSlots: _timeSlots,
                    onSlotsChanged: (slots) {
                      if (mounted) {
                        setState(() {
                          _timeSlots = slots;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tables configuration
                  TableConfiguration(
                    initialTables: _tables,
                    onTablesChanged: (tables) {
                      if (mounted) {
                        setState(() {
                          _tables = tables;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: state.isLoading ? null : _saveRestaurant,
                      icon: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(
                        isEditing ? 'Update Restaurant' : 'Create Restaurant',
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (state.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Restaurant Image',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 48,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to add restaurant image',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
          ),
        ),
        if (_imageFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () {
                if (mounted) {
                  setState(() => _imageFile = null);
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Remove Image',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sales Point Location *',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            FilledButton.tonalIcon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text('Use Current'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            hintText: 'Address will appear here',
            prefixIcon: Icon(Icons.location_on),
            border: OutlineInputBorder(),
          ),
          readOnly: true,
          maxLines: 2,
          validator: (value) {
            if (_location == null) {
              return 'Please set restaurant location';
            }
            return null;
          },
        ),
        if (_location != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Coordinates: ${_location!.latitude.toStringAsFixed(6)}, ${_location!.longitude.toStringAsFixed(6)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }
}
