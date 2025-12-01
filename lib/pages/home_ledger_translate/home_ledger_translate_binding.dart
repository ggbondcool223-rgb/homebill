import 'package:get/get.dart';

import 'home_ledger_translate_logic.dart';

class HomeLedgerTranslateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      HomeLedgerTranslateLogic(),
      permanent: true,
    );
  }
}
