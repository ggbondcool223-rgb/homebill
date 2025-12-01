import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_ledger_expense_categories_logic.dart';

class HomeLedgerExpenseCategoriesView
    extends GetView<HomeLedgerExpenseCategoriesLogic> {
  const HomeLedgerExpenseCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text('Expense Categories'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            child: TextButton.icon(
              onPressed: controller.addCategory,
              icon: const Icon(Icons.add, color: Colors.white, size: 18),
              label: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final systemCategories = controller.categories.where((c) => c.isSystem).toList();
        final customCategories = controller.categories.where((c) => !c.isSystem).toList();
        
        return SingleChildScrollView(
          child: Column(
            children: [
              if (systemCategories.isNotEmpty) _buildSystemCategories(systemCategories),
              _buildCustomCategories(customCategories),
              _buildInfoCard(),
              SizedBox(height: 20.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSystemCategories(List categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 12.h),
          child: Text(
            'System Categories',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey[200]),
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(
                category: category,
                onToggle: () => controller.toggleCategory(category),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomCategories(List categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
          child: Text(
            'Custom Categories',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: categories.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey[200]),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryItem(
                    category: category,
                    onEdit: () => controller.editCategory(category),
                    onDelete: () => controller.deleteCategory(category),
                  );
                },
              ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    required dynamic category,
    VoidCallback? onToggle,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    final isSystem = category.isSystem;
    final enabled = category.isEnabled;
    
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Text(category.categoryIcon, style: TextStyle(fontSize: 20.sp)),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.categoryName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: enabled ? Colors.black : Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSystem
                          ? const Color(0xFFF3F4F6)
                          : const Color(0xFFDCEEFE),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      isSystem ? 'System' : 'Custom',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isSystem
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSystem)
            _buildToggleSwitch(enabled, onToggle)
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue[600], size: 20.sp),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[400], size: 20.sp),
                  onPressed: onDelete,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch(bool enabled, VoidCallback? onToggle) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: 51.w,
        height: 31.h,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF10B981) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 27.w,
            height: 27.h,
            margin: EdgeInsets.all(2.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(48.w),
      child: Column(
        children: [
          Text('📋', style: TextStyle(fontSize: 50.sp)),
          SizedBox(height: 12.h),
          Text(
            'No custom categories',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Tap + to add a new category',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: const Color(0xFF3B82F6), size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Categories',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'System categories cannot be deleted, but can be disabled. Disabled categories won\'t appear when adding records, but existing records are preserved.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1E40AF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
