import 'package:get/get.dart';
import 'home_ledger_statistics_logic.dart';

class HomeLedgerStatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerStatisticsLogic());
  }
}

