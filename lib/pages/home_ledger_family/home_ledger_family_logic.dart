import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../db_home_ledger/data.dart';
import '../../db_home_ledger/db_home_ledger_entity.dart';
import '../../utils/index.dart';
import '../../component/text_field.dart';

class HomeLedgerFamilyLogic extends GetxController {
  final db = HomeLedgerDatabase();

  final family = Rxn<FamilyEntity>();

  final members = <MemberEntity>[].obs;

  final currentMonth = DateFormat('yyyy-MM').format(DateTime.now());

  final incomeTarget = Rxn<IncomeTargetEntity>();
  final monthlyIncome = 0.0.obs;
  final incomeProgress = 0.0.obs;

  final expenseBudget = Rxn<ExpenseBudgetEntity>();
  final monthlyExpense = 0.0.obs;
  final budgetUsage = 0.0.obs;
  final remainingBudget = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadFamily();
    await _loadMembers();
    await _loadIncomeTarget();
    await _loadExpenseBudget();
    await _calculateMonthlyData();
  }

  Future<void> _loadFamily() async {
    try {
      family.value = await db.getFamily();
    } catch (e) {
      errorToast('Failed to load family info');
    }
  }

  Future<void> _loadMembers() async {
    try {
      members.value = await db.getAllMembers();
    } catch (e) {
      errorToast('Failed to load members');
    }
  }

  Future<void> _loadIncomeTarget() async {
    try {
      incomeTarget.value = await db.getIncomeTargetByMonth(currentMonth);
    } catch (e) {
      errorToast('Failed to load income target');
    }
  }

  Future<void> _loadExpenseBudget() async {
    try {
      expenseBudget.value = await db.getExpenseBudgetByMonth(currentMonth);
    } catch (e) {
      errorToast('Failed to load expense budget');
    }
  }

  Future<void> _calculateMonthlyData() async {
    try {
      monthlyIncome.value = await db.getMonthlyIncome(currentMonth);
      monthlyExpense.value = await db.getMonthlyExpense(currentMonth);

      if (incomeTarget.value != null && incomeTarget.value!.monthlyTarget > 0) {
        incomeProgress.value =
            (monthlyIncome.value / incomeTarget.value!.monthlyTarget).clamp(
              0.0,
              1.0,
            );
      }

      if (expenseBudget.value != null &&
          expenseBudget.value!.monthlyBudget > 0) {
        budgetUsage.value =
            monthlyExpense.value / expenseBudget.value!.monthlyBudget;
        remainingBudget.value =
            expenseBudget.value!.monthlyBudget - monthlyExpense.value;
      }
    } catch (e) {
      errorToast('Failed to calculate monthly data');
    }
  }

  Future<void> editFamilyName() async {
    String familyName = family.value?.familyName ?? 'My Home';

    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Edit Family Name'),
        content: MyTextField(
          value: familyName,
          onChange: (value) => familyName = value,
          hintText: 'Enter family name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: familyName),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final updatedFamily = family.value!;
        updatedFamily.familyName = result;
        await db.updateFamily(updatedFamily);
        family.value = updatedFamily;
        family.refresh();
        successToast('Family name updated');
      } catch (e) {
        errorToast('Failed to update family name');
      }
    }
  }

  Future<void> addMember() async {
    String memberName = '';
    String selectedRole = 'member';

    final result = await Get.dialog<Map<String, dynamic>>(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Member'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: MyTextField(
                    value: memberName,
                    onChange: (value) => memberName = value,
                    hintText: 'Member name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'member', child: Text('Member')),
                    DropdownMenuItem(value: 'child', child: Text('Child')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(
                  result: {'name': memberName, 'role': selectedRole},
                ),
                child: const Text('Add'),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && result['name'].toString().isNotEmpty) {
      try {
        final member = MemberEntity(
          memberName: result['name'],
          role: result['role'],
        );
        await db.insertMember(member);
        await _loadMembers();
        await _loadFamily();
        successToast('Member added successfully');
      } catch (e) {
        errorToast('Failed to add member');
      }
    }
  }

  Future<void> deleteMember(MemberEntity member) async {
    if (members.length <= 1) {
      errorToast('At least one member required');
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Member'),
        content: Text('Are you sure you want to remove ${member.memberName}?'),
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
        await db.deleteMember(member.id!);
        await _loadMembers();
        await _loadFamily();
        successToast('Member removed');
      } catch (e) {
        errorToast('Failed to remove member');
      }
    }
  }

  Future<void> setIncomeTarget() async {
    String targetAmount =
        incomeTarget.value?.monthlyTarget.toStringAsFixed(2) ?? '';

    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Set Income Target'),
        content: MyTextField(
          value: targetAmount,
          onChange: (value) => targetAmount = value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Enter target amount',
          isNumber: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: targetAmount),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final amount = double.tryParse(result);
      if (amount == null || amount <= 0) {
        errorToast('Please enter a valid amount');
        return;
      }

      try {
        final target = IncomeTargetEntity(
          monthlyTarget: amount,
          month: currentMonth,
        );
        await db.setIncomeTarget(target);
        await _loadIncomeTarget();
        await _calculateMonthlyData();
        successToast('Income target set successfully');
      } catch (e) {
        errorToast('Failed to set income target');
      }
    }
  }

  Future<void> setExpenseBudget() async {
    String budgetAmount =
        expenseBudget.value?.monthlyBudget.toStringAsFixed(2) ?? '';

    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Set Expense Budget'),
        content: MyTextField(
          value: budgetAmount,
          onChange: (value) => budgetAmount = value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          hintText: 'Enter budget amount',
          isNumber: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF3B82F6)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: budgetAmount),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final amount = double.tryParse(result);
      if (amount == null || amount <= 0) {
        errorToast('Please enter a valid amount');
        return;
      }

      try {
        final budget = ExpenseBudgetEntity(
          monthlyBudget: amount,
          month: currentMonth,
        );
        await db.setExpenseBudget(budget);
        await _loadExpenseBudget();
        await _calculateMonthlyData();
        successToast('Expense budget set successfully');
      } catch (e) {
        errorToast('Failed to set expense budget');
      }
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }
}
