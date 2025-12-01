import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'home_ledger_ledger_logic.dart';

class HomeLedgerLedgerView extends GetView<HomeLedgerLedgerLogic> {
  const HomeLedgerLedgerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ledger')),
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),
              _buildMonthSelector(),
              _buildSummaryCards(),
              _buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Obx(() {
      final monthYear = DateFormat(
        'MMMM yyyy',
      ).format(controller.selectedMonth.value);

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: controller.previousMonth,
              icon: Icon(
                Icons.chevron_left,
                color: Colors.grey[700],
                size: 24.sp,
              ),
            ),
            Text(
              monthYear,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            IconButton(
              onPressed: controller.nextMonth,
              icon: Icon(
                Icons.chevron_right,
                color: Colors.grey[700],
                size: 24.sp,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCards() {
    return Obx(() {
      final expenseStr =
          '-\$${controller.monthlyExpense.value.toStringAsFixed(2)}';
      final incomeStr =
          '+\$${controller.monthlyIncome.value.toStringAsFixed(2)}';
      final balanceStr =
          '\$${controller.totalSavings.value.toStringAsFixed(2)}';

      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Expense',
                expenseStr,
                const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSummaryCard(
                'Income',
                incomeStr,
                const Color(0xFFFF9800),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildSummaryCard(
                'Balance',
                balanceStr,
                const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryCard(String label, String amount, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
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
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Obx(() {
      if (controller.recordsByDate.isEmpty) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text('📝', style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                'No Records Yet',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tap + to add your first record',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              child: Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
            ...controller.recordsByDate.entries.expand((entry) {
              final date = entry.key;
              final records = entry.value;

              final recordsByMember = <int, List<RecordWithDetails>>{};
              for (var record in records) {
                final memberId = record.member.id!;
                if (recordsByMember.containsKey(memberId)) {
                  recordsByMember[memberId]!.add(record);
                } else {
                  recordsByMember[memberId] = [record];
                }
              }

              return recordsByMember.entries.map((memberEntry) {
                final memberRecords = memberEntry.value;
                final member = memberRecords.first.member;
                final memberTotal = controller.getDailyTotal(memberRecords);
                final groupKey = '${date}_${member.id}';

                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildDateGroup(
                    date,
                    member.memberName,
                    memberTotal,
                    memberRecords,
                    groupKey: groupKey,
                  ),
                );
              });
            }).toList(),
            SizedBox(height: 80.h),
          ],
        ),
      );
    });
  }

  Widget _buildDateGroup(
    String date,
    String userName,
    double total,
    List<RecordWithDetails> records, {
    String? groupKey,
  }) {
    final key = groupKey ?? date;
    final totalStr = total >= 0
        ? '+\$${total.toStringAsFixed(2)}'
        : '-\$${(-total).toStringAsFixed(2)}';

    return Container(
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
          InkWell(
            onTap: () => controller.toggleDate(key),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: records.isEmpty
                    ? BorderRadius.circular(16.r)
                    : BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                border: Border(
                  bottom: records.isEmpty
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: const Color(0xFF3B82F6),
                    child: Text(
                      userName[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
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
                          userName,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    totalStr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: total < 0
                          ? const Color(0xFF10B981)
                          : const Color(0xFFFF9800),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => Icon(
                      controller.isExpanded(key) && records.isNotEmpty
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.grey[400],
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.isExpanded(key) && records.isNotEmpty) {
              return Column(
                children: records
                    .asMap()
                    .entries
                    .map(
                      (entry) => _buildRecordItem(entry.value, entry.key + 1),
                    )
                    .toList(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildRecordItem(RecordWithDetails recordWithDetails, int number) {
    final record = recordWithDetails.record;
    final category = recordWithDetails.category;
    final isIncome = record.type == 'income';

    final amountStr = isIncome
        ? '+\$${record.amount.toStringAsFixed(2)}'
        : '-\$${record.amount.toStringAsFixed(2)}';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFFFFF3E0)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Text(
              category.categoryIcon,
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      '${record.time} · #$number',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (record.note != null && record.note!.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          record.note!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            amountStr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? const Color(0xFFFF9800)
                  : const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }
}
