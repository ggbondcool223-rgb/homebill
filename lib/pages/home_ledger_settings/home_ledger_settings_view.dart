import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_ledger_settings_logic.dart';
import '../home_ledger_tab/home_ledger_tab_logic.dart';

class HomeLedgerSettingsView extends GetView<HomeLedgerSettingsLogic> {
  const HomeLedgerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildCategoryManagement(),
            _buildDataManagement(),
            _buildAbout(),
            _buildAppInfo(),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryManagement() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 12.h),
            child: Text(
              'Category Management',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.arrow_upward,
                  iconBgColor: const Color(0xFFFFF3E0),
                  iconColor: const Color(0xFFFF9800),
                  title: 'Income Categories',
                  subtitle: 'Manage income types',
                  trailing: '(${controller.incomeCategoryCount.value})',
                  onTap: () async {
                    await Get.toNamed('/home_ledger_income_categories');
                    await controller.refresh();
                    _refreshAllTabs();
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                _buildMenuItem(
                  icon: Icons.arrow_downward,
                  iconBgColor: const Color(0xFFE8F5E9),
                  iconColor: const Color(0xFF10B981),
                  title: 'Expense Categories',
                  subtitle: 'Manage expense types',
                  trailing: '(${controller.expenseCategoryCount.value})',
                  onTap: () async {
                    await Get.toNamed('/home_ledger_expense_categories');
                    await controller.refresh();
                    _refreshAllTabs();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDataManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
          child: Text(
            'Data Management',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.cloud_upload,
                iconBgColor: const Color(0xFFDCEEFE),
                iconColor: const Color(0xFF3B82F6),
                title: 'Backup Data',
                subtitle: 'Export all data to file',
                onTap: controller.backupData,
              ),
              Divider(height: 1, color: Colors.grey[200]),
              _buildMenuItem(
                icon: Icons.cloud_download,
                iconBgColor: const Color(0xFFEDE9FE),
                iconColor: const Color(0xFF9333EA),
                title: 'Restore Data',
                subtitle: 'Import data from backup file',
                onTap: controller.restoreData,
              ),
              Divider(height: 1, color: Colors.grey[200]),
              _buildMenuItem(
                icon: Icons.delete_forever,
                iconBgColor: const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFEF4444),
                title: 'Clear All Data',
                subtitle: 'Delete all records permanently',
                titleColor: const Color(0xFFEF4444),
                onTap: controller.clearAllData,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
          child: Text(
            'About',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildMenuItem(
            icon: Icons.info,
            iconBgColor: const Color(0xFFF3F4F6),
            iconColor: const Color(0xFF6B7280),
            title: 'Version',
            subtitle: 'Current app version',
            trailing: '1.0.0',
            showArrow: false,
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Text(
            'HomeLedger',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
          ),
          SizedBox(height: 4.h),
          Text(
            'Family Finance Management App',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
          ),
          SizedBox(height: 8.h),
          Text(
            'Made with ❤️ for families',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _refreshAllTabs() {
    try {
      final tabLogic = Get.find<HomeLedgerTabLogic>();
      tabLogic.refreshAllTabs();
    } catch (e) {
      
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? trailing,
    Color? titleColor,
    bool showArrow = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showArrow) SizedBox(width: 8.w),
            ],
            if (showArrow)
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
          ],
        ),
      ),
    );
  }
}
