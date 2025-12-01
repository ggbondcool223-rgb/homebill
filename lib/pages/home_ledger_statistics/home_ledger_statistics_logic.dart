import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../db_home_ledger/data.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';
import '../../utils/index.dart';

class HomeLedgerStatisticsLogic extends GetxController {
  final db = HomeLedgerDatabase();
  
  final selectedMonth = DateTime.now().obs;
  
  
  final selectedTab = 0.obs; 
  
  final touchedExpenseIndex = (-1).obs;
  final touchedIncomeIndex = (-1).obs;
  
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final netAmount = 0.0.obs;
  final avgDailyExpense = 0.0.obs;
  
  final incomeCategoryStats = <CategoryStat>[].obs;
  final expenseCategoryStats = <CategoryStat>[].obs;
  
  final memberStats = <MemberStat>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await _calculateOverview();
    await _calculateCategoryStats();
    await _calculateMemberStats();
  }

  Future<void> _calculateOverview() async {
    try {
      final month = DateFormat('yyyy-MM').format(selectedMonth.value);
      
      totalIncome.value = await db.getMonthlyIncome(month);
      totalExpense.value = await db.getMonthlyExpense(month);
      
      netAmount.value = totalIncome.value - totalExpense.value;
      
      final daysInMonth = DateTime(
        selectedMonth.value.year,
        selectedMonth.value.month + 1,
        0,
      ).day;
      avgDailyExpense.value = totalExpense.value / daysInMonth;
    } catch (e) {
      errorToast('Failed to calculate overview');
    }
  }

  Future<void> _calculateCategoryStats() async {
    try {
      final month = DateFormat('yyyy-MM').format(selectedMonth.value);
      final startDate = '$month-01';
      final endDate = DateFormat('yyyy-MM-dd').format(
        DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0),
      );
      
      final incomeByCategory = await db.getAmountByCategory('income', startDate, endDate);
      final incomeCategories = await db.getCategoriesByType('income');
      
      final incomeStats = <CategoryStat>[];
      for (var entry in incomeByCategory.entries) {
        final category = incomeCategories.firstWhereOrNull((c) => c.id == entry.key);
        if (category != null && entry.value > 0) {
          incomeStats.add(CategoryStat(
            category: category,
            amount: entry.value,
            percentage: totalIncome.value > 0 ? entry.value / totalIncome.value : 0,
          ));
        }
      }
      
      incomeStats.sort((a, b) => b.amount.compareTo(a.amount));
      incomeCategoryStats.value = incomeStats;
      
      final expenseByCategory = await db.getAmountByCategory('expense', startDate, endDate);
      final expenseCategories = await db.getCategoriesByType('expense');
      
      final expenseStats = <CategoryStat>[];
      for (var entry in expenseByCategory.entries) {
        final category = expenseCategories.firstWhereOrNull((c) => c.id == entry.key);
        if (category != null && entry.value > 0) {
          expenseStats.add(CategoryStat(
            category: category,
            amount: entry.value,
            percentage: totalExpense.value > 0 ? entry.value / totalExpense.value : 0,
          ));
        }
      }
      
      expenseStats.sort((a, b) => b.amount.compareTo(a.amount));
      expenseCategoryStats.value = expenseStats;
    } catch (e) {
      errorToast('Failed to calculate category stats');
    }
  }

  Future<void> _calculateMemberStats() async {
    try {
      final month = DateFormat('yyyy-MM').format(selectedMonth.value);
      final startDate = '$month-01';
      final endDate = DateFormat('yyyy-MM-dd').format(
        DateTime(selectedMonth.value.year, selectedMonth.value.month + 1, 0),
      );
      
      final expenseByMember = await db.getExpenseByMember(startDate, endDate);
      final members = await db.getAllMembers();
      
      final stats = <MemberStat>[];
      for (var entry in expenseByMember.entries) {
        final member = members.firstWhereOrNull((m) => m.id == entry.key);
        if (member != null && entry.value > 0) {
          stats.add(MemberStat(
            member: member,
            amount: entry.value,
            percentage: totalExpense.value > 0 ? entry.value / totalExpense.value : 0,
          ));
        }
      }
      
      stats.sort((a, b) => b.amount.compareTo(a.amount));
      memberStats.value = stats;
    } catch (e) {
      errorToast('Failed to calculate member stats');
    }
  }

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    _loadData();
  }

  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    _loadData();
  }

  
  void switchTab(int index) {
    selectedTab.value = index;
  }

  Future<void> refresh() async {
    await _loadData();
  }
}

class CategoryStat {
  final CategoryEntity category;
  final double amount;
  final double percentage;

  CategoryStat({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

class MemberStat {
  final MemberEntity member;
  final double amount;
  final double percentage;

  MemberStat({
    required this.member,
    required this.amount,
    required this.percentage,
  });
}

