import 'package:get/get.dart';
import 'home_ledger_expense_categories_logic.dart';

class HomeLedgerExpenseCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerExpenseCategoriesLogic());
  }
}

