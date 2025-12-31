import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/widgets/custom_dropdown.dart';
import 'package:mrpos/shared/widgets/custom_form_field.dart';

class AddMenuItemModal extends StatefulWidget {
  final MenuItem? itemToEdit;

  const AddMenuItemModal({super.key, this.itemToEdit});

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
  String? _selectedCategoryName;
  String? _selectedMenuTypeName;
  String _selectedStockStatus = 'instock';
  bool _isAvailable = true;
  bool _isPerishable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
      _selectedMenuTypeName = item.menuType;
      _selectedCategoryName = item.category;
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

  Future<void> _saveMenuItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final cubit = context.read<MenuCubit>();

      try {
        if (widget.itemToEdit != null) {
          // EDIT MODE
          final updatedItem = widget.itemToEdit!.copyWith(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _selectedCategoryName!,
            quantity: int.tryParse(_quantityController.text) ?? 0,
            stockStatus: _selectedStockStatus,
            isPerishable: _isPerishable,
            price: double.tryParse(_priceController.text) ?? 0.0,
            costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
            isAvailable: _isAvailable,
            menuType: _selectedMenuTypeName!,
          );
          await cubit.updateMenuItem(updatedItem);
        } else {
          // ADD MODE
          final newItem = MenuItem(
            id: '', // Firestore will generate
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            itemId: '#${DateTime.now().millisecondsSinceEpoch % 10000000}',
            image: '', // Default or handle upload
            quantity: int.tryParse(_quantityController.text) ?? 0,
            stockStatus: _selectedStockStatus,
            isPerishable: _isPerishable,
            category: _selectedCategoryName!,
            price: double.tryParse(_priceController.text) ?? 0.0,
            costPrice: double.tryParse(_costPriceController.text) ?? 0.0,
            isAvailable: _isAvailable,
            menuType: _selectedMenuTypeName!,
          );
          await cubit.addMenuItem(newItem);
        }

        if (mounted) {
          final itemName = _nameController.text.trim();
          final action = widget.itemToEdit != null ? 'updated' : 'added';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Menu item "$itemName" $action successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save menu item: ${e.toString()}'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        List<MenuCategory> categories = [];
        List<MenuType> menuTypes = [];

        if (state is MenuLoaded) {
          categories = state.categories.where((cat) => cat.id != '1').toList();
          menuTypes = state.menuTypes;
        }

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
                            CustomFormField(
                              controller: _nameController,
                              label: AppStrings.productName,
                              hint: 'Enter product name',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a product name';
                                }
                                return null;
                              },
                            ),
                            16.h,

                            CustomDropdown<String>(
                              label: AppStrings.category,
                              hint: 'Select category',
                              value: _selectedCategoryName,
                              items: categories.map((cat) {
                                return DropdownMenuItem<String>(
                                  value: cat.name,
                                  child: Text(cat.name),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedCategoryName = value),
                              validator: (value) =>
                                  value == null ? 'Required' : null,
                            ),
                            16.h,

                            CustomDropdown<String>(
                              label: 'Menu Type',
                              hint: 'Select menu type',
                              value: _selectedMenuTypeName,
                              items: menuTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type.name,
                                  child: Text(type.name),
                                );
                              }).toList(),
                              onChanged: (value) =>
                                  setState(() => _selectedMenuTypeName = value),
                              validator: (value) =>
                                  value == null ? 'Required' : null,
                            ),
                            16.h,

                            CustomFormField(
                              controller: _quantityController,
                              label: 'Quantity',
                              hint: 'Enter quantity',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            16.h,

                            CustomDropdown<String>(
                              label: 'Stock Status',
                              hint: 'Select status',
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
                              onChanged: (value) =>
                                  setState(() => _selectedStockStatus = value!),
                            ),
                            16.h,

                            CustomFormField(
                              controller: _priceController,
                              label: AppStrings.price,
                              hint: 'Enter price',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            16.h,

                            CustomFormField(
                              controller: _costPriceController,
                              label: 'Cost Price',
                              hint: 'Enter cost price',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            16.h,

                            CustomFormField(
                              controller: _descriptionController,
                              label: AppStrings.description,
                              hint: 'Enter description',
                              maxLines: 4,
                            ),
                            16.h,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Perishable'),
                                Switch(
                                  value: _isPerishable,
                                  onChanged: (v) =>
                                      setState(() => _isPerishable = v),
                                  activeColor: AppColors.primaryRed,
                                ),
                              ],
                            ),
                            16.h,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Availability'),
                                Switch(
                                  value: _isAvailable,
                                  onChanged: (v) =>
                                      setState(() => _isAvailable = v),
                                  activeColor: AppColors.primaryRed,
                                ),
                              ],
                            ),
                            24.h,

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                16.w,
                                CustomButton.primary(
                                  text: widget.itemToEdit != null
                                      ? 'Update'
                                      : 'Save',
                                  isLoading: _isLoading,
                                  onPressed: () {
                                    _saveMenuItem();
                                  },
                                  height: 40,
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
      },
    );
  }
}
