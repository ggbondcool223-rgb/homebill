import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../db_home_ledger/data.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';
import '../../utils/index.dart';
import '../../component/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeLedgerIncomeCategoriesLogic extends GetxController {
  final db = HomeLedgerDatabase();

  final categories = <CategoryEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      categories.value = await db.getAllCategoriesByType('income');
    } catch (e) {
      errorToast('Failed to load categories');
    }
  }

  Future<void> toggleCategory(CategoryEntity category) async {
    try {
      category.isEnabled = !category.isEnabled;
      await db.updateCategory(category);
      await _loadCategories();
      successToast(
        category.isEnabled ? 'Category enabled' : 'Category disabled',
      );
    } catch (e) {
      errorToast('Failed to update category');
    }
  }

  Future<void> addCategory() async {
    String categoryName = '';
    String categoryIcon = '';

    final result = await Get.dialog<Map<String, String>>(
      AlertDialog(
        title: const Text('Add Income Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              value: categoryName,
              onChange: (value) => categoryName = value,
              hintText: 'Category name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              textStyle: TextStyle(fontSize: 14.sp),
            ),
            const SizedBox(height: 16),
            MyTextField(
              value: categoryIcon,
              onChange: (value) => categoryIcon = value,
              hintText: 'Emoji icon (e.g., 💰)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              textStyle: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () =>
                Get.back(result: {'name': categoryName, 'icon': categoryIcon}),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result['name']!.isNotEmpty) {
      try {
        final exists = await db.isCategoryNameExists(result['name']!, 'income');
        if (exists) {
          errorToast('Category name already exists');
          return;
        }

        final category = CategoryEntity(
          categoryName: result['name']!,
          categoryIcon: result['icon']!.isNotEmpty ? result['icon']! : '📝',
          type: 'income',
          isSystem: false,
          isEnabled: true,
          sortOrder: categories.length,
        );

        await db.insertCategory(category);
        await _loadCategories();
        successToast('Category added successfully');
      } catch (e) {
        errorToast('Failed to add category');
      }
    }
  }

  Future<void> editCategory(CategoryEntity category) async {
    if (category.isSystem) {
      errorToast('System categories cannot be edited');
      return;
    }

    String categoryName = category.categoryName;
    String categoryIcon = category.categoryIcon;

    final result = await Get.dialog<Map<String, String>>(
      AlertDialog(
        title: const Text('Edit Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              value: categoryName,
              onChange: (value) => categoryName = value,
              hintText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              textStyle: TextStyle(fontSize: 14.sp),
            ),
            const SizedBox(height: 16),
            MyTextField(
              value: categoryIcon,
              onChange: (value) => categoryIcon = value,
              hintText: 'Icon',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF3B82F6)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              textStyle: TextStyle(fontSize: 14.sp),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () =>
                Get.back(result: {'name': categoryName, 'icon': categoryIcon}),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result['name']!.isNotEmpty) {
      try {
        final exists = await db.isCategoryNameExists(
          result['name']!,
          'income',
          excludeId: category.id,
        );
        if (exists) {
          errorToast('Category name already exists');
          return;
        }

        category.categoryName = result['name']!;
        category.categoryIcon = result['icon']!.isNotEmpty
            ? result['icon']!
            : category.categoryIcon;

        await db.updateCategory(category);
        await _loadCategories();
        successToast('Category updated successfully');
      } catch (e) {
        errorToast('Failed to update category');
      }
    }
  }

  Future<void> deleteCategory(CategoryEntity category) async {
    if (category.isSystem) {
      errorToast('System categories cannot be deleted');
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Are you sure you want to delete "${category.categoryName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await db.deleteCategory(category.id!);
        await _loadCategories();
        successToast('Category deleted successfully');
      } catch (e) {
        errorToast('Failed to delete category');
      }
    }
  }

  Future<void> refresh() async {
    await _loadCategories();
  }
}
