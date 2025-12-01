import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'home_ledger_add_record_logic.dart';
import '../../component/text_field.dart';

class HomeLedgerAddRecordView extends GetView<HomeLedgerAddRecordLogic> {
  const HomeLedgerAddRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: const Text('Add Record')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildIncomeCategories(),
            _buildExpenseCategories(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Obx(() {
      final isIncome = controller.selectedType.value == 'income';
      final color = isIncome
          ? const Color(0xFFFF9800)
          : const Color(0xFF10B981);
      final type = isIncome
          ? 'Income'
          : (controller.selectedType.value == 'expense' ? 'Expense' : '');

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (controller.currentExpression.value.isNotEmpty)
              Text(
                controller.currentExpression.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    '$type:',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '\$${controller.amount.value == '0' ? '0.00' : controller.amount.value}',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          Divider(height: 1, color: Colors.grey[200]),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => _showDatePicker(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                Obx(
                  () => Row(
                    children: [
                      Text(
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(controller.selectedDate.value),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.calendar_today,
                        size: 14.sp,
                        color: const Color(0xFF3B82F6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => _showMemberPicker(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Member',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                Obx(() {
                  final member = controller.selectedMember.value;
                  if (member == null) {
                    return Text(
                      'Select member',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                      ),
                    );
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 12.r,
                        backgroundColor: const Color(0xFF3B82F6),
                        child: Text(
                          member.memberName[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        member.memberName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 14.sp,
                        color: Colors.grey[400],
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Note',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(width: 32.w),
              Expanded(
                child: Obx(
                  () => MyTextField(
                    value: controller.note.value,
                    onChange: controller.updateNote,
                    hintText: 'Click to add note',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 2.h,
                    ),
                    textStyle: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              GestureDetector(
                onTap: () => controller.addTagToNote('Salary'),
                child: _buildTag('Salary', false),
              ),
              GestureDetector(
                onTap: () => controller.addTagToNote('Food'),
                child: _buildTag('Food', false),
              ),
              GestureDetector(
                onTap: () => controller.addTagToNote('Transport'),
                child: _buildTag('Transport', false),
              ),
              GestureDetector(
                onTap: () => controller.addTagToNote('Entertainment'),
                child: _buildTag('Entertainment', false),
              ),
              GestureDetector(
                onTap: () => controller.addTagToNote('Bonus'),
                child: _buildTag('Bonus', false),
              ),
              GestureDetector(
                onTap: () => controller.addTagToNote('Other'),
                child: _buildTag('Other', false),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFDCEEFE) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildIncomeCategories() {
    return Obx(() {
      final categories = controller.incomeCategories;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  color: const Color(0xFFFF9800),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'INCOME',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Obx(
                  () => _buildCategoryItem(
                    icon: category.categoryIcon,
                    name: category.categoryName,
                    isSelected:
                        controller.selectedCategory.value?.id == category.id &&
                        controller.selectedType.value == 'income',
                    bgColor: const Color(0xFFFFF3E0),
                    selectedColor: const Color(0xFFFF9800),
                    onTap: () {
                      controller.selectCategory(category, 'income');
                      _showDetailBottomSheet();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildExpenseCategories() {
    return Obx(() {
      final categories = controller.expenseCategories;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8F5E9), Colors.white],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_downward,
                  color: const Color(0xFF10B981),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'EXPENSE',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Obx(
                  () => _buildCategoryItem(
                    icon: category.categoryIcon,
                    name: category.categoryName,
                    isSelected:
                        controller.selectedCategory.value?.id == category.id &&
                        controller.selectedType.value == 'expense',
                    bgColor: const Color(0xFFE8F5E9),
                    selectedColor: const Color(0xFF10B981),
                    onTap: () {
                      controller.selectCategory(category, 'expense');
                      _showDetailBottomSheet();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryItem({
    required String icon,
    required String name,
    required bool isSelected,
    required Color bgColor,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: TextStyle(fontSize: 24.sp)),
            SizedBox(height: 4.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? selectedColor : Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculator() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      child: Column(
        children: [
          _buildCalculatorRow(['7', '8', '9', '÷']),
          SizedBox(height: 8.h),
          _buildCalculatorRow(['4', '5', '6', '×']),
          SizedBox(height: 8.h),
          _buildCalculatorRow(['1', '2', '3', '-']),
          SizedBox(height: 8.h),
          _buildCalculatorRow(['.', '0', '⌫', '+']),
          SizedBox(height: 8.h),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildCalculatorRow(List<String> buttons) {
    return Row(
      children: buttons.map((button) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: _buildCalculatorButton(button),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalculatorButton(String label) {
    final isOperator = ['÷', '×', '-', '+'].contains(label);
    final isDelete = label == '⌫';

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.onCalculatorButtonPressed(label),
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: isDelete
                    ? Colors.red
                    : isOperator
                    ? const Color(0xFF3B82F6)
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.setDate(picked);
    }
  }

  void _showMemberPicker() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Member',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, size: 20.sp),
                  ),
                ],
              ),
            ),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.members.length,
                itemBuilder: (context, index) {
                  final member = controller.members[index];
                  final isSelected =
                      controller.selectedMember.value?.id == member.id;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? const Color(0xFF3B82F6)
                          : Colors.grey[400],
                      child: Text(
                        member.memberName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(member.memberName),
                    subtitle: Text(member.role),
                    trailing: isSelected
                        ? Icon(Icons.check, color: const Color(0xFF3B82F6))
                        : null,
                    onTap: () {
                      controller.selectMember(member);
                      Get.back();
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.saveRecord(),
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Save  ',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Obx(
                  () => Text(
                    '\$${controller.amount.value == '0' ? '0.00' : controller.amount.value}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailBottomSheet() {
    controller.resetAmount();
    Get.bottomSheet(
      Container(
        height: 0.85.sh,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildAmountDisplay(),
                    SizedBox(height: 8.h),
                    _buildInfoSection(),
                    SizedBox(height: 8.h),
                    _buildCalculator(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }
}
