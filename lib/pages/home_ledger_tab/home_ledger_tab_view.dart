import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_ledger_tab_logic.dart';
import '../home_ledger_ledger/home_ledger_ledger_view.dart';
import '../home_ledger_statistics/home_ledger_statistics_view.dart';
import '../home_ledger_family/home_ledger_family_view.dart';
import '../home_ledger_settings/home_ledger_settings_view.dart';

class HomeLedgerTabView extends GetView<HomeLedgerTabLogic> {
  const HomeLedgerTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeLedgerLedgerView(),
      const HomeLedgerStatisticsView(),
      const HomeLedgerFamilyView(),
      const HomeLedgerSettingsView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: [
              _buildTabItem(index: 0, icon: Icons.book, label: 'Ledger'),
              _buildTabItem(
                index: 1,
                icon: Icons.pie_chart,
                label: 'Statistics',
              ),
              _buildAddButton(),
              _buildTabItem(index: 3, icon: Icons.people, label: 'Family'),
              _buildTabItem(index: 4, icon: Icons.person, label: 'Me'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final actualIndex = index > 2 ? index - 1 : index;
    return Expanded(
      child: Obx(() {
        final isActive = controller.currentIndex.value == actualIndex;
        return GestureDetector(
          onTap: () => controller.changeTab(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: isActive
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF9CA3AF),
              ),
              SizedBox(height: 2.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  color: isActive
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: 80.w,
      child: GestureDetector(
        onTap: () async {
          await Get.toNamed('/home_ledger_add_record');
          await controller.refreshAllTabs();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -14.h),
              child: Container(
                width: 56.w,
                height: 56.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x403B82F6),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.add, color: Colors.white, size: 32.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
