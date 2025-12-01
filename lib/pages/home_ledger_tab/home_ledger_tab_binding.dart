import 'package:get/get.dart';
import 'home_ledger_tab_logic.dart';
import '../home_ledger_ledger/home_ledger_ledger_logic.dart';
import '../home_ledger_statistics/home_ledger_statistics_logic.dart';
import '../home_ledger_family/home_ledger_family_logic.dart';
import '../home_ledger_settings/home_ledger_settings_logic.dart';

class HomeLedgerTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerTabLogic());
    Get.lazyPut(() => HomeLedgerLedgerLogic());
    Get.lazyPut(() => HomeLedgerStatisticsLogic());
    Get.lazyPut(() => HomeLedgerFamilyLogic());
    Get.lazyPut(() => HomeLedgerSettingsLogic());
  }
}

