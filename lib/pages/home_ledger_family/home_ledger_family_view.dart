import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'home_ledger_family_logic.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';

class HomeLedgerFamilyView extends GetView<HomeLedgerFamilyLogic> {
  const HomeLedgerFamilyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: Text('Family')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFamilyHeader(),
            _buildFamilyMembers(),
            _buildIncomeTarget(),
            _buildExpenseBudget(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyHeader() {
    return Obx(() {
      final familyName = controller.family.value?.familyName ?? 'My Home';
      
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: controller.editFamilyName,
                    child: Row(
                      children: [
                        Text(
                          familyName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.edit,
                          color: Colors.white.withOpacity(0.75),
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Manage your family finances together',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text('👨‍👩‍👧‍👦', style: TextStyle(fontSize: 50.sp)),
          ],
        ),
      );
    });
  }

  Widget _buildFamilyMembers() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(20.w),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Family Members',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: controller.addMember,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: const Color(0xFF3B82F6), size: 18.sp),
                      SizedBox(width: 4.w),
                      Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...controller.members.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;
              final colors = [
                const Color(0xFF3B82F6),
                const Color(0xFFEC4899),
                const Color(0xFF10B981),
                const Color(0xFFF59E0B),
                const Color(0xFF8B5CF6),
              ];
              final color = colors[index % colors.length];
              
              return Padding(
                padding: EdgeInsets.only(bottom: index < controller.members.length - 1 ? 12.h : 0),
                child: _buildMemberItem(member, color),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildMemberItem(MemberEntity member, Color color) {
    final joinDate = member.joinTime != null 
      ? DateFormat('MMM dd, yyyy').format(member.joinTime!)
      : 'N/A';
    final roleCapitalized = member.role[0].toUpperCase() + member.role.substring(1);
    
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: color,
            child: Text(
              member.memberName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.memberName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$roleCapitalized · Joined $joinDate',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: member.role == 'admin'
                      ? const Color(0xFFDCEEFE)
                      : member.role == 'member'
                      ? const Color(0xFFF3F4F6)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  roleCapitalized,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: member.role == 'admin'
                        ? const Color(0xFF3B82F6)
                        : member.role == 'member'
                        ? const Color(0xFF6B7280)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
              if (controller.members.length > 1) ...[
                SizedBox(width: 8.w),
                IconButton(
                  onPressed: () => controller.deleteMember(member),
                  icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.sp),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeTarget() {
    return Obx(() {
      final target = controller.incomeTarget.value?.monthlyTarget ?? 0.0;
      final current = controller.monthlyIncome.value;
      final progress = controller.incomeProgress.value;
      final progressPercent = (progress * 100).toStringAsFixed(2);
      
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(20.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flag, color: const Color(0xFFFF9800), size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Income Target',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: controller.setIncomeTarget,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Target',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              target > 0 ? '\$${target.toStringAsFixed(2)}' : 'Not Set',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.edit, color: Colors.grey[400], size: 20.sp),
                      ],
                    ),
                    if (target > 0) ...[
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${current.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFFFF9800),
                          ),
                          minHeight: 8.h,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '$progressPercent%',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildExpenseBudget() {
    return Obx(() {
      final budget = controller.expenseBudget.value?.monthlyBudget ?? 0.0;
      final used = controller.monthlyExpense.value;
      final usage = controller.budgetUsage.value;
      final remaining = controller.remainingBudget.value;
      final usagePercent = (usage * 100).toStringAsFixed(2);
      final isOverBudget = used > budget && budget > 0;
      final progressColor = isOverBudget ? Colors.red : const Color(0xFF10B981);
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(20.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: const Color(0xFF10B981),
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Expense Budget',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: controller.setExpenseBudget,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isOverBudget 
                      ? [const Color(0xFFFEE2E2), const Color(0xFFFECACA)]
                      : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Budget',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              budget > 0 ? '\$${budget.toStringAsFixed(2)}' : 'Not Set',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: isOverBudget ? Colors.red : const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.edit, color: Colors.grey[400], size: 20.sp),
                      ],
                    ),
                    if (budget > 0) ...[
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Used',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '\$${used.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isOverBudget ? Colors.red : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: usage.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                          minHeight: 8.h,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Usage',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '$usagePercent%',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: progressColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Remaining',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '\$${remaining.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: progressColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
