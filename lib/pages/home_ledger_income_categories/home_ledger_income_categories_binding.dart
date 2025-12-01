import 'package:get/get.dart';
import 'home_ledger_income_categories_logic.dart';

class HomeLedgerIncomeCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerIncomeCategoriesLogic());
  }
}

