import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrpos/core/constants/app_constants.dart';
import 'package:mrpos/core/constants/mock_data.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_cubit.dart';
import 'package:mrpos/features/menu/presentation/cubit/menu_state.dart';
import 'package:mrpos/features/menu/presentation/widgets/add_category_modal.dart';
import 'package:mrpos/shared/theme/app_colors.dart';
import 'package:mrpos/shared/widgets/category_card.dart';
import 'package:mrpos/shared/widgets/custom_button.dart';
import 'package:mrpos/shared/utils/extensions.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is! MenuLoaded) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.categories,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      4.h,
                      Text(
                        'Organize your menu items by category',
                        style: TextStyle(
                          color: context.isDarkMode
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                16.w,
                Flexible(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CustomButton.primary(
                      text: AppStrings.addNewCategory,
                      onPressed: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: 'Add Category',
                          barrierColor: Colors.black54,
                          transitionDuration: const Duration(milliseconds: 300),
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                                return const AddCategoryModal();
                              },
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position:
                                      Tween<Offset>(
                                        begin: const Offset(1, 0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                  child: child,
                                );
                              },
                        );
                      },
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.h,
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: MenuMockData.categories.length,
                separatorBuilder: (context, index) => 12.w,
                itemBuilder: (context, index) {
                  final category = MenuMockData.categories[index];
                  return CategoryCard(
                    category: category,
                    isSelected: state.selectedCategoryId == category.id,
                    onTap: () =>
                        context.read<MenuCubit>().selectCategory(category.id),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
