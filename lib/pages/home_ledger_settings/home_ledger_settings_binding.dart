import 'package:get/get.dart';
import 'home_ledger_settings_logic.dart';

class HomeLedgerSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLedgerSettingsLogic());
  }
}

