import 'dart:io';
import 'package:e_commerce_app_flutter/views/pages/add_category_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app_flutter/models/add_product_model/add_product_model.dart';
import 'package:e_commerce_app_flutter/provider/add_product_provider.dart';
import 'package:e_commerce_app_flutter/provider/category_provider.dart';

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
                        onTap: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              _imageFile = File(pickedFile.path);
                            });
                          }
                        },
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(category.name),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final shouldRemove =
                                            await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title:
                                                const Text('Remove Category'),
                                            content: Text(
                                                'Are you sure you want to remove the category "${category.name}"?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (shouldRemove ?? false) {
                                          await categoryProvider
                                              .removeCategory(category.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
                            label: Text(color.name),
                            selected: _selectedColors.contains(color),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedColors.add(color);
                                } else {
                                  _selectedColors.remove(color);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sizes',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ProductSize.values.map((size) {
                          return ChoiceChip(
                            label: Text(size.name),
                            selected: _selectedSizes.contains(size),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSizes.add(size);
                                } else {
                                  _selectedSizes.remove(size);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Consumer<AddProductProvider>(
                          builder: (context, addProductProvider, child) {
                            return addProductProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        if (_imageFile == null) {
                                          Fluttertoast.showToast(
                                            msg: "Please select an image.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                          );
                                          return;
                                        }

                                        final addProductModel = AddProductModel(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          name: _name,
                                          description: _description,
                                          price: _price,
                                          category: _category,
                                          inStock: _inStock,
                                          colors: _selectedColors,
                                          sizes: _selectedSizes,
                                          imgUrl: '',
                                        );

                                        await addProductProvider.addProduct(
                                            addProductModel, _imageFile!);

                                        if (!addProductProvider.isLoading) {
                                          Fluttertoast.showToast(
                                            msg: "Product added successfully",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                          );
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Add Product'),
                                  );
                          },
                        ),
                      ),
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
