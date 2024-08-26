import 'dart:io';
import 'package:e_commerce_app_flutter/views/pages/add_category_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:e_commerce_app_flutter/provider/add_product_provider.dart';
import 'package:e_commerce_app_flutter/provider/category_provider.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  File? _imageFile;
  double _price = 0.0;
  String _description = '';
  String _category = '';
  int _inStock = 0;
  List<ProductColor> _selectedColors = [];
  List<ProductSize> _selectedSizes = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _toggleColor(ProductColor color) {
    setState(() {
      if (_selectedColors.contains(color)) {
        _selectedColors.remove(color);
      } else {
        _selectedColors.add(color);
      }
    });
  }

  Future<void> _submit() async {
    if (_selectedColors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one color')),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final provider = Provider.of<AddProductProvider>(context, listen: false);

      await provider.addProduct(
        _name,
        _imageFile,
        _price,
        _description,
        _category,
        _inStock,
        _selectedColors,
        _selectedSizes,
      );

      if (provider.state == AddProductState.loaded) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add product: ${provider.errorMessage}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer2<AddProductProvider, CategoryProvider>(
              builder: (context, addProductProvider, categoryProvider, child) {
                if (categoryProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryProvider.errorMessage != null) {
                  return Center(
                      child: Text('Error: ${categoryProvider.errorMessage}'));
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter product name',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Product Image',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _pickImage,
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('Tap to pick image'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Price',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter price',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Category',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          if (categoryProvider.isLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (categoryProvider.errorMessage != null) {
                            return Center(
                                child: Text(
                                    'Error: ${categoryProvider.errorMessage}'));
                          }

                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Select category',
                              prefixIcon: const Icon(Icons.category),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  final newCategory =
                                      await Navigator.push<String>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddCategoryPage(),
                                    ),
                                  );
                                  if (newCategory != null &&
                                      newCategory.isNotEmpty) {
                                    setState(() {
                                      _category = newCategory;
                                    });
                                    categoryProvider.fetchCategories();
                                  }
                                },
                              ),
                            ),
                            value: _category.isEmpty ? null : _category,
                            items: categoryProvider.categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _category = value ?? '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'In Stock',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter stock quantity',
                          prefixIcon: Icon(Icons.store),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _inStock = int.parse(value!);
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Colors',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ProductColor.values.map((color) {
                          return ChoiceChip(
                            label: Text(color.toString().split('.').last),
                            selected: _selectedColors.contains(color),
                            onSelected: (selected) {
                              _toggleColor(color);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed:
                              context.watch<AddProductProvider>().isSubmitting
                                  ? null
                                  : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Add Product',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
