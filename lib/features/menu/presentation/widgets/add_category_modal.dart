import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/utils/extensions.dart';
import 'package:mrpos/shared/utils/icon_detector.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/widgets/custom_dropdown.dart';
import 'package:mrpos/shared/widgets/custom_form_field.dart';

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  State<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  IconData _previewIcon = FontAwesomeIcons.utensils;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateIconPreview(String name) {
    setState(() {
      _previewIcon = IconDetector.detectIcon(name);
    });
  }

  bool _isDuplicateCategory(String name) {
    return MenuMockData.categories.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase().trim(),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final categoryName = _nameController.text.trim();

      // Check for duplicates
      if (_isDuplicateCategory(categoryName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "$categoryName" already exists!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Generate new category ID
      final newId = 'cat_${DateTime.now().millisecondsSinceEpoch}';
      final iconKey = IconDetector.getIconKey(categoryName);

      // Create new category
      final newCategory = MenuCategory(
        id: newId,
        name: categoryName,
        iconKey: iconKey,
        itemCount: 0,
        description: _descriptionController.text.trim(),
        iconData: IconDetector.detectIcon(categoryName),
      );

      // Add to mock data
      MenuMockData.categories.add(newCategory);

      // Show success message with icon info
      final hasIcon = iconKey != 'default';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasIcon
                ? 'Category "$categoryName" created with ${iconKey} icon!'
                : 'Category "$categoryName" created with default icon!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Close modal
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;

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
                      AppStrings.addNewCategory,
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
                        // Icon Preview
                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  _previewIcon,
                                  size: 48,
                                  color: AppColors.primaryRed,
                                ),
                                8.h,
                                Text(
                                  'Icon Preview',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        24.h,

                        // Category Name
                        CustomFormField(
                          controller: _nameController,
                          label: 'Category Name',
                          hint: 'Enter category name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a category name';
                            }
                            if (value.trim().length < 2) {
                              return 'Category name must be at least 2 characters';
                            }
                            return null;
                          },
                          onChanged: _updateIconPreview,
                        ),
                        16.h,

                        16.h,

                        // Description
                        CustomFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Write your category description here',
                          maxLines: 4,
                          maxLength: 200,
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
                              onPressed: _saveCategory,
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
