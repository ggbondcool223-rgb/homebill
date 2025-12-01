import 'package:get/get.dart';
import 'home_ledger_family_logic.dart';

class HomeLedgerFamilyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerFamilyLogic());
  }
}

