import 'package:get/get.dart';
import '../home_ledger_ledger/home_ledger_ledger_logic.dart';
import '../home_ledger_statistics/home_ledger_statistics_logic.dart';
import '../home_ledger_family/home_ledger_family_logic.dart';

class HomeLedgerTabLogic extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    if (index == 2) return;
    final newIndex = index > 2 ? index - 1 : index;
    
    _refreshTabData(newIndex);
    
    currentIndex.value = newIndex;
  }

  Future<void> _refreshTabData(int index) async {
    try {
      switch (index) {
        case 0:
          final ledgerLogic = Get.find<HomeLedgerLedgerLogic>();
          await ledgerLogic.refresh();
          break;
        case 1:
          final statisticsLogic = Get.find<HomeLedgerStatisticsLogic>();
          await statisticsLogic.refresh();
          break;
        case 2:
          final familyLogic = Get.find<HomeLedgerFamilyLogic>();
          await familyLogic.refresh();
          break;
      }
    } catch (e) {
    }
  }

  Future<void> refreshAllTabs() async {
    try {
      try {
        final ledgerLogic = Get.find<HomeLedgerLedgerLogic>();
        await ledgerLogic.refresh();
      } catch (e) {}
      
      try {
        final statisticsLogic = Get.find<HomeLedgerStatisticsLogic>();
        await statisticsLogic.refresh();
      } catch (e) {}
      
      try {
        final familyLogic = Get.find<HomeLedgerFamilyLogic>();
        await familyLogic.refresh();
      } catch (e) {}
    } catch (e) {
    }
  }
}

