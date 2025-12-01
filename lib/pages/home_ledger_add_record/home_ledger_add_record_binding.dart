import 'package:get/get.dart';
import 'home_ledger_add_record_logic.dart';

class HomeLedgerAddRecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerAddRecordLogic());
  }
}

