import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/features/menu/domain/models/menu_models.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/widgets/custom_form_field.dart';

class AddMenuTypeModal extends StatefulWidget {
  final MenuType? menuTypeToEdit;

  const AddMenuTypeModal({super.key, this.menuTypeToEdit});

  @override
  State<AddMenuTypeModal> createState() => _AddMenuTypeModalState();
}

class _AddMenuTypeModalState extends State<AddMenuTypeModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.menuTypeToEdit != null) {
      _nameController.text = widget.menuTypeToEdit!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveMenuType() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final menuTypeName = _nameController.text.trim();
      final cubit = context.read<MenuCubit>();

      try {
        if (widget.menuTypeToEdit != null) {
          // EDIT MODE
          final updatedType = widget.menuTypeToEdit!.copyWith(
            name: menuTypeName,
          );
          await cubit.updateMenuType(updatedType);
        } else {
          // ADD MODE
          final newMenuType = MenuType(
            id: '', // Firestore will generate the ID
            name: menuTypeName,
            displayOrder: 0, // Simplified for now, or get from state
          );
          await cubit.addMenuType(newMenuType);
        }

        if (mounted) {
          final action = widget.menuTypeToEdit != null ? 'updated' : 'added';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Menu type "$menuTypeName" $action successfully!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save menu type: ${e.toString()}'),
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
    final isEditing = widget.menuTypeToEdit != null;

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: screenWidth > 600 ? 450 : screenWidth * 0.85,
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
                      isEditing ? 'Edit Menu Type' : 'Add Menu Type',
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
                          label: 'Menu Type Name',
                          hint: 'e.g., Lunch Special, Happy Hour',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a menu type name';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        24.h,

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                              12.w,
                              Expanded(
                                child: Text(
                                  'Menu types help organize your menu items (e.g., Normal Menu, Special Deals, Seasonal Items)',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        32.h,

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
                              text: isEditing ? 'Update' : 'Save',
                              isLoading: _isLoading,
                              onPressed: () {
                                _saveMenuType();
                              },
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
