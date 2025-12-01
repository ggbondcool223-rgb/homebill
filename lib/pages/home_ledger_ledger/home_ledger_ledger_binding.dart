import 'package:get/get.dart';
import 'home_ledger_ledger_logic.dart';

class HomeLedgerLedgerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerLedgerLogic());
  }
}

