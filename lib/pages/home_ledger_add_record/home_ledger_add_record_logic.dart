import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../db_home_ledger/data.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';
import '../../utils/index.dart';

class HomeLedgerAddRecordLogic extends GetxController {
  final db = HomeLedgerDatabase();

  final selectedCategory = Rxn<CategoryEntity>();
  final selectedType = ''.obs; 

  final amount = '0'.obs;
  final currentExpression = ''.obs;

  final selectedDate = DateTime.now().obs;
  final selectedMember = Rxn<MemberEntity>();

  final note = ''.obs;

  final incomeCategories = <CategoryEntity>[].obs;
  final expenseCategories = <CategoryEntity>[].obs;

  final members = <MemberEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    _loadMembers();
  }

  Future<void> _loadCategories() async {
    try {
      incomeCategories.value = await db.getCategoriesByType('income');
      expenseCategories.value = await db.getCategoriesByType('expense');
    } catch (e) {
      errorToast('Failed to load categories');
    }
  }

  Future<void> _loadMembers() async {
    try {
      members.value = await db.getAllMembers();
      if (members.isNotEmpty) {
        selectedMember.value = members.first;
      }
    } catch (e) {
      errorToast('Failed to load members');
    }
  }

  void selectCategory(CategoryEntity category, String type) {
    selectedCategory.value = category;
    selectedType.value = type;
  }

  
  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void selectMember(MemberEntity member) {
    selectedMember.value = member;
  }

  void updateNote(String value) {
    note.value = value;
  }

  void addTagToNote(String tag) {
    if (note.value.isEmpty) {
      note.value = tag;
    } else {
      note.value += ' $tag';
    }
  }

  void resetAmount() {
    amount.value = '0';
    currentExpression.value = '';
  }

  void onCalculatorButtonPressed(String button) {
    if (button == '⌫') {
      if (currentExpression.value.isNotEmpty) {
        currentExpression.value = currentExpression.value.substring(
          0,
          currentExpression.value.length - 1,
        );
        _calculateExpression();
      }
    } else if (button == '=') {
      _calculateExpression();
      saveRecord();
    } else if (['+', '-', '×', '÷'].contains(button)) {
      if (currentExpression.value.isNotEmpty &&
          !['+', '-', '×', '÷'].contains(
            currentExpression.value[currentExpression.value.length - 1],
          )) {
        currentExpression.value += button;
      }
    } else if (button == '.') {
      final parts = currentExpression.value.split(RegExp(r'[+\-×÷]'));
      if (parts.isNotEmpty && !parts.last.contains('.')) {
        if (parts.last.isEmpty) {
          currentExpression.value += '0.';
        } else {
          currentExpression.value += '.';
        }
      }
    } else {
      if (currentExpression.value == '0') {
        currentExpression.value = button;
      } else {
        currentExpression.value += button;
      }
    }

    _calculateExpression();
  }

  void _calculateExpression() {
    try {
      if (currentExpression.value.isEmpty || currentExpression.value == '0') {
        amount.value = '0';
        return;
      }

      String expr = currentExpression.value;

      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');

      if (['+', '-', '*', '/'].contains(expr[expr.length - 1])) {
        expr = expr.substring(0, expr.length - 1);
      }

      if (expr.isEmpty) {
        amount.value = '0';
        return;
      }

      final result = _evaluateExpression(expr);

      amount.value = result.toStringAsFixed(2);
    } catch (e) {
    }
  }

  double _evaluateExpression(String expr) {
    final addSubParts = <String>[];
    final addSubOps = <String>[];
    var current = '';

    for (int i = 0; i < expr.length; i++) {
      final char = expr[i];
      if ((char == '+' || char == '-') && current.isNotEmpty && i > 0) {
        addSubParts.add(current);
        addSubOps.add(char);
        current = '';
      } else {
        current += char;
      }
    }
    if (current.isNotEmpty) {
      addSubParts.add(current);
    }

    final values = addSubParts.map((part) => _evaluateMultDiv(part)).toList();

    double result = values[0];
    for (int i = 0; i < addSubOps.length; i++) {
      if (addSubOps[i] == '+') {
        result += values[i + 1];
      } else {
        result -= values[i + 1];
      }
    }

    return result;
  }

  double _evaluateMultDiv(String expr) {
    final parts = <String>[];
    final ops = <String>[];
    var current = '';

    for (int i = 0; i < expr.length; i++) {
      final char = expr[i];
      if ((char == '*' || char == '/') && current.isNotEmpty) {
        parts.add(current);
        ops.add(char);
        current = '';
      } else {
        current += char;
      }
    }
    if (current.isNotEmpty) {
      parts.add(current);
    }

    if (parts.isEmpty) return 0;
    if (parts.length == 1) return double.tryParse(parts[0]) ?? 0;

    double result = double.tryParse(parts[0]) ?? 0;
    for (int i = 0; i < ops.length; i++) {
      final value = double.tryParse(parts[i + 1]) ?? 0;
      if (ops[i] == '*') {
        result *= value;
      } else {
        if (value != 0) {
          result /= value;
        }
      }
    }

    return result;
  }

  Future<void> saveRecord() async {
    try {
      if (selectedCategory.value == null) {
        errorToast('Please select a category');
        return;
      }

      final amountValue = double.tryParse(amount.value);
      if (amountValue == null || amountValue <= 0) {
        errorToast('Please enter a valid amount');
        return;
      }

      if (amountValue > 9999999.99) {
        errorToast('Amount exceeds maximum limit');
        return;
      }

      if (selectedMember.value == null) {
        errorToast('Please select a member');
        return;
      }

      final now = DateTime.now();
      final record = RecordEntity(
        type: selectedType.value,
        categoryId: selectedCategory.value!.id!,
        amount: amountValue,
        date: DateFormat('yyyy-MM-dd').format(selectedDate.value),
        time: DateFormat('HH:mm:ss').format(now),
        note: note.value.isEmpty ? null : note.value,
        memberId: selectedMember.value!.id!,
      );

      await db.insertRecord(record);

      successToast('Record saved successfully');

      Get.back();
      Get.back();
    } catch (e) {
      errorToast('Failed to save record: ${e.toString()}');
    }
  }
}
