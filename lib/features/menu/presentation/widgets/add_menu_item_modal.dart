import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/widgets/custom_dropdown.dart';
import 'package:mrpos/shared/widgets/custom_form_field.dart';

class AddMenuItemModal extends StatefulWidget {
  final MenuItem? itemToEdit;
  final VoidCallback? onSaved;

  const AddMenuItemModal({super.key, this.itemToEdit, this.onSaved});

  @override
  State<AddMenuItemModal> createState() => _AddMenuItemModalState();
}

class _AddMenuItemModalState extends State<AddMenuItemModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _costPriceController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedMenuType;
  String _selectedStockStatus = 'instock';
  bool _isAvailable = true;
  bool _isPerishable = true;

  @override
  void initState() {
    super.initState();
    // If editing, pre-fill the form
    if (widget.itemToEdit != null) {
      final item = widget.itemToEdit!;
      _nameController.text = item.name;
      _descriptionController.text = item.description;
      _quantityController.text = item.quantity.toString();
      _priceController.text = item.price.toString();
      _costPriceController.text = item.costPrice.toString();
      _selectedStockStatus = item.stockStatus;
      _isAvailable = item.isAvailable;
      _isPerishable = item.isPerishable;
      _selectedMenuType = item.menuType;

      // Find category ID by name
      final category = MenuMockData.categories.firstWhere(
        (cat) => cat.name == item.category,
        orElse: () => MenuMockData.categories.first,
      );
      _selectedCategoryId = category.id;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _costPriceController.dispose();
    super.dispose();
  }

  void _saveMenuItem() {
    if (_formKey.currentState!.validate()) {
      // Get selected category
      final category = MenuMockData.categories.firstWhere(
        (cat) => cat.id == _selectedCategoryId,
      );

      if (widget.itemToEdit != null) {
        // EDIT MODE - Update existing item
        final index = MenuMockData.menuItems.indexWhere(
          (item) => item.id == widget.itemToEdit!.id,
        );

        if (index != -1) {
          MenuMockData.menuItems[index] = MenuItem(
            id: widget.itemToEdit!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            category: category.name,
            itemId: widget.itemToEdit!.itemId,
            quantity: int.tryParse(_quantityController.text) ?? 0,
            stockStatus: _selectedStockStatus,
            isPerishable: _isPerishable,
            price: double.tryParse(_priceController.text) ?? 0.0,
            costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
            image: widget.itemToEdit!.image,
            isAvailable: _isAvailable,
            menuType: _selectedMenuType ?? 'Normal Menu',
          );
        }
      } else {
        // ADD MODE - Create new item
        final autoItemId = '#${DateTime.now().millisecondsSinceEpoch}';

        final newItem = MenuItem(
          id: 'item_${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          category: category.name,
          itemId: autoItemId,
          quantity: int.tryParse(_quantityController.text) ?? 0,
          stockStatus: _selectedStockStatus,
          isPerishable: _isPerishable,
          price: double.tryParse(_priceController.text) ?? 0.0,
          costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
          image: '',
          isAvailable: _isAvailable,
          menuType: _selectedMenuType ?? 'Normal Menu',
        );

        MenuMockData.menuItems.add(newItem);

        // Update category item count
        final categoryIndex = MenuMockData.categories.indexWhere(
          (cat) => cat.id == _selectedCategoryId,
        );
        if (categoryIndex != -1) {
          final updatedCategory = MenuCategory(
            id: category.id,
            name: category.name,
            iconAsset: category.iconAsset,
            iconData: category.iconData,
            itemCount: category.itemCount + 1,
            iconKey: category.iconKey,
            description: category.description,
          );
          MenuMockData.categories[categoryIndex] = updatedCategory;
        }
      }

      // Show success message FIRST (while context is still valid)
      final itemName = _nameController.text.trim();
      final action = widget.itemToEdit != null ? 'updated' : 'added';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu item "$itemName" $action successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Trigger callback to refresh UI immediately
      widget.onSaved?.call();

      // Small delay to ensure snackbar is shown, then close modal
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    // Get categories for dropdown (exclude "All")
    final availableCategories = MenuMockData.categories
        .where((cat) => cat.id != '1')
        .toList();

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenWidth > 600 ? 500 : screenWidth * 0.85,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(-5, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFF2A2A2A)
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.itemToEdit != null
                          ? 'Edit Menu Item'
                          : AppStrings.addMenuItem,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product Name
                        CustomFormField(
                          controller: _nameController,
                          label: AppStrings.productName,
                          hint: 'Enter product name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a product name';
                            }
                            if (value.trim().length < 2) {
                              return 'Product name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        16.h,

                        // Select Category
                        CustomDropdown<String>(
                          label: AppStrings.category,
                          hint: 'Select category',
                          value: _selectedCategoryId,
                          items: availableCategories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                        16.h,

                        // Select Menu Type
                        CustomDropdown<String>(
                          label: 'Menu Type',
                          hint: 'Select menu type',
                          value: _selectedMenuType,
                          items: MenuMockData.menuTypes.map((menuType) {
                            return DropdownMenuItem<String>(
                              value: menuType.name,
                              child: Text(menuType.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMenuType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a menu type';
                            }
                            return null;
                          },
                        ),
                        16.h,

                        // Quantity
                        CustomFormField(
                          controller: _quantityController,
                          label: 'Quantity',
                          hint: 'Enter quantity',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        16.h,

                        // Stock Status
                        CustomDropdown<String>(
                          label: 'Stock Status',
                          hint: 'Select stock status',
                          value: _selectedStockStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'instock',
                              child: Text('In Stock'),
                            ),
                            DropdownMenuItem(
                              value: 'lowstock',
                              child: Text('Low Stock'),
                            ),
                            DropdownMenuItem(
                              value: 'outofstock',
                              child: Text('Out of Stock'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStockStatus = value!;
                            });
                          },
                        ),
                        16.h,

                        // Price
                        CustomFormField(
                          controller: _priceController,
                          label: AppStrings.price,
                          hint: 'Enter price',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                        16.h,
                        // Cost Price
                        CustomFormField(
                          controller: _costPriceController,
                          label: 'Cost Price',
                          hint: 'Enter cost price',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter cost price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid cost price';
                            }
                            return null;
                          },
                        ),
                        16.h,

                        // Description
                        CustomFormField(
                          controller: _descriptionController,
                          label: AppStrings.description,
                          hint: 'Enter product description',
                          maxLines: 4,
                          maxLength: 300,
                        ),
                        16.h,

                        // Perishable Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Perishable',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Switch(
                              value: _isPerishable,
                              onChanged: (value) {
                                setState(() {
                                  _isPerishable = value;
                                });
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ],
                        ),
                        8.h,
                        Text(
                          _isPerishable ? 'Yes' : 'No',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        16.h,

                        // Availability Toggle
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.availability,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                            Switch(
                              value: _isAvailable,
                              onChanged: (value) {
                                setState(() {
                                  _isAvailable = value;
                                });
                              },
                              activeColor: AppColors.primaryRed,
                            ),
                          ],
                        ),
                        8.h,
                        Text(
                          _isAvailable ? 'Available' : 'Unavailable',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: _isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                        24.h,

                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                            16.w,
                            CustomButton.primary(
                              text: 'Save',
                              onPressed: _saveMenuItem,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
