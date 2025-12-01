import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../db_home_ledger/data.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';
import '../../utils/index.dart';

class HomeLedgerLedgerLogic extends GetxController {
  final db = HomeLedgerDatabase();
  
  final expandedDates = <String>{}.obs;
  
  final selectedMonth = DateTime.now().obs;
  
  final family = Rxn<FamilyEntity>();
  
  final recordsByDate = RxMap<String, List<RecordWithDetails>>({});
  
  final monthlyIncome = 0.0.obs;
  final monthlyExpense = 0.0.obs;
  final totalSavings = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadFamily();
    await _loadMonthlyRecords();
    await _calculateMonthlySummary();
    await _calculateTotalSavings();
  }

  Future<void> _loadFamily() async {
    try {
      family.value = await db.getFamily();
    } catch (e) {
      errorToast('Failed to load family info');
    }
  }

  Future<void> _loadMonthlyRecords() async {
    try {
      final month = DateFormat('yyyy-MM').format(selectedMonth.value);
      final records = await db.getRecordsByMonth(month);
      
      final grouped = <String, List<RecordWithDetails>>{};
      
      for (var record in records) {
        final category = await db.getCategoryById(record.categoryId);
        final member = await db.getMemberById(record.memberId);
        
        if (category != null && member != null) {
          final recordWithDetails = RecordWithDetails(
            record: record,
            category: category,
            member: member,
          );
          
          if (grouped.containsKey(record.date)) {
            grouped[record.date]!.add(recordWithDetails);
          } else {
            grouped[record.date] = [recordWithDetails];
          }
        }
      }
      
      final sortedKeys = grouped.keys.toList()
        ..sort((a, b) => b.compareTo(a));
      
      final sortedMap = <String, List<RecordWithDetails>>{};
      for (var key in sortedKeys) {
        sortedMap[key] = grouped[key]!;
      }
      
      recordsByDate.value = sortedMap;
    } catch (e) {
      errorToast('Failed to load records');
    }
  }

  Future<void> _calculateMonthlySummary() async {
    try {
      final month = DateFormat('yyyy-MM').format(selectedMonth.value);
      monthlyIncome.value = await db.getMonthlyIncome(month);
      monthlyExpense.value = await db.getMonthlyExpense(month);
    } catch (e) {
      errorToast('Failed to calculate summary');
    }
  }

  Future<void> _calculateTotalSavings() async {
    try {
      totalSavings.value = await db.getTotalSavings();
    } catch (e) {
      errorToast('Failed to calculate savings');
    }
  }

  void toggleDate(String date) {
    if (expandedDates.contains(date)) {
      expandedDates.remove(date);
    } else {
      expandedDates.add(date);
    }
  }

  bool isExpanded(String date) {
    return expandedDates.contains(date);
  }

  void previousMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
    _loadMonthlyRecords();
    _calculateMonthlySummary();
  }

  void nextMonth() {
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
    _loadMonthlyRecords();
    _calculateMonthlySummary();
  }

  Future<void> refresh() async {
    await _loadData();
  }

  double getDailyTotal(List<RecordWithDetails> records) {
    double total = 0;
    for (var record in records) {
      total += record.record.displayAmount;
    }
    return total;
  }
}

class RecordWithDetails {
  final RecordEntity record;
  final CategoryEntity category;
  final MemberEntity member;

  RecordWithDetails({
    required this.record,
    required this.category,
    required this.member,
  });
}

