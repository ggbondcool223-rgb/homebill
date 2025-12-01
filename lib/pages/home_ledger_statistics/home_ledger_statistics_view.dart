import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'home_ledger_statistics_logic.dart';

class HomeLedgerStatisticsView extends GetView<HomeLedgerStatisticsLogic> {
  const HomeLedgerStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(elevation: 0, title: Text('Statistics')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTimeFilter(),
            _buildOverviewCards(),
            _buildExpenseChart(),
            _buildIncomeChart(),
            _buildCategoryRanking(),
            _buildMemberStats(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Obx(() {
      final monthYear = DateFormat(
        'MMMM yyyy',
      ).format(controller.selectedMonth.value);

      return Container(
        margin: EdgeInsets.all(16.w),
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
            Column(
              children: [
                Text(
                  monthYear,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Monthly Report',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
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

  Widget _buildOverviewCards() {
    return Obx(() {
      final incomeStr = '\$${controller.totalIncome.value.toStringAsFixed(2)}';
      final expenseStr =
          '\$${controller.totalExpense.value.toStringAsFixed(2)}';
      final netStr = controller.netAmount.value >= 0
          ? '\$${controller.netAmount.value.toStringAsFixed(2)}'
          : '-\$${(-controller.netAmount.value).toStringAsFixed(2)}';
      final avgStr = '\$${controller.avgDailyExpense.value.toStringAsFixed(2)}';
      final netColor = controller.netAmount.value >= 0
          ? const Color(0xFF10B981)
          : const Color(0xFFEF4444);

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard(
                    'Total Income',
                    incomeStr,
                    '',
                    const Color(0xFFFF9800),
                    false,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildOverviewCard(
                    'Total Expense',
                    expenseStr,
                    '',
                    const Color(0xFF10B981),
                    false,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewCard(
                    'Net Amount',
                    netStr,
                    '',
                    netColor,
                    false,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildOverviewCard(
                    'Avg Daily',
                    avgStr,
                    '',
                    const Color(0xFF6B7280),
                    false,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOverviewCard(
    String label,
    String amount,
    String change,
    Color color,
    bool isPositive,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (change.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  Icons.arrow_upward,
                  size: 12.sp,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                SizedBox(width: 2.w),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpenseChart() {
    return Obx(() {
      final stats = controller.expenseCategoryStats;

      if (stats.isEmpty) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text('📊', style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                'No Expense Data',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expense Breakdown',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${stats.length} categories',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildExpensePieChart(stats),
          ],
        ),
      );
    });
  }

  Widget _buildIncomeChart() {
    return Obx(() {
      final stats = controller.incomeCategoryStats;

      if (stats.isEmpty) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text('📊', style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                'No Income Data',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Income Breakdown',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${stats.length} categories',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildIncomePieChart(stats),
            SizedBox(height: 20.h),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryRanking() {
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
        children: [
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.switchTab(0),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 0
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Expense Ranking',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: controller.selectedTab.value == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: controller.selectedTab.value == 0
                              ? const Color(0xFF3B82F6)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.switchTab(1),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: controller.selectedTab.value == 1
                                ? const Color(0xFF3B82F6)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        'Income Ranking',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: controller.selectedTab.value == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: controller.selectedTab.value == 1
                              ? const Color(0xFF3B82F6)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            final stats = controller.selectedTab.value == 0
                ? controller.expenseCategoryStats
                : controller.incomeCategoryStats;

            if (stats.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ),
              );
            }

            return Column(
              children: stats.asMap().entries.map((entry) {
                final index = entry.key;
                final stat = entry.value;
                return _buildRankingItem(
                  index + 1,
                  stat.category.categoryIcon,
                  stat.category.categoryName,
                  '\$${stat.amount.toStringAsFixed(2)}',
                  '${(stat.percentage * 100).toStringAsFixed(1)}%',
                  stat.percentage,
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRankingItem(
    int rank,
    String icon,
    String category,
    String amount,
    String percentage,
    double percentageValue,
  ) {
    final rankColor = rank == 1
        ? const Color(0xFFFBBF24)
        : rank == 2
        ? const Color(0xFF9CA3AF)
        : rank == 3
        ? const Color(0xFFF59E0B)
        : const Color(0xFF6B7280);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              rank.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: TextStyle(fontSize: 18.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentageValue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 2.h),
              Text(
                percentage,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberStats() {
    return Obx(() {
      final stats = controller.memberStats;

      if (stats.isEmpty) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(40.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Text('👥', style: TextStyle(fontSize: 48.sp)),
              SizedBox(height: 16.h),
              Text(
                'No Member Data',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      }

      final colors = [
        const Color(0xFF3B82F6),
        const Color(0xFFEC4899),
        const Color(0xFF10B981),
        const Color(0xFFF59E0B),
        const Color(0xFF8B5CF6),
      ];

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
            Text(
              'Member Consumption',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            ...stats.asMap().entries.map((entry) {
              final index = entry.key;
              final stat = entry.value;
              final color = colors[index % colors.length];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < stats.length - 1 ? 12.h : 0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: color,
                      child: Text(
                        stat.member.memberName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
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
                            stat.member.memberName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            stat.member.role[0].toUpperCase() +
                                stat.member.role.substring(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${stat.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${(stat.percentage * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildExpensePieChart(List<CategoryStat> stats) {
    final colors = [
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
    ];

    return Obx(() {
      final touchedIndex = controller.touchedExpenseIndex.value;

      return Column(
        children: [
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      controller.touchedExpenseIndex.value = -1;
                      return;
                    }
                    controller.touchedExpenseIndex.value =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 50.r,
                sections: List.generate(stats.length > 8 ? 8 : stats.length, (
                  i,
                ) {
                  final isTouched = i == touchedIndex;
                  final radius = isTouched ? 65.r : 55.r;
                  final fontSize = isTouched ? 14.sp : 12.sp;
                  final stat = stats[i];

                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: stat.amount,
                    title: '${(stat.percentage * 100).toStringAsFixed(0)}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 2),
                      ],
                    ),
                  );
                }),
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: List.generate(stats.length > 8 ? 8 : stats.length, (i) {
              final stat = stats[i];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${stat.category.categoryIcon} ${stat.category.categoryName}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _buildIncomePieChart(List<CategoryStat> stats) {
    final colors = [
      const Color(0xFFFF9800),
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFEC4899),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
    ];

    return Obx(() {
      final touchedIndex = controller.touchedIncomeIndex.value;

      return Column(
        children: [
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      controller.touchedIncomeIndex.value = -1;
                      return;
                    }
                    controller.touchedIncomeIndex.value =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 50.r,
                sections: List.generate(stats.length > 8 ? 8 : stats.length, (
                  i,
                ) {
                  final isTouched = i == touchedIndex;
                  final radius = isTouched ? 65.r : 55.r;
                  final fontSize = isTouched ? 14.sp : 12.sp;
                  final stat = stats[i];

                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: stat.amount,
                    title: '${(stat.percentage * 100).toStringAsFixed(0)}%',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black26, blurRadius: 2),
                      ],
                    ),
                  );
                }),
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 8.h,
            children: List.generate(stats.length > 8 ? 8 : stats.length, (i) {
              final stat = stats[i];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${stat.category.categoryIcon} ${stat.category.categoryName}',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[800]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            }),
          ),
        ],
      );
    });
  }
}
