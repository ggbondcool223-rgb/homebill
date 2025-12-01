import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../db_home_ledger/data.dart';
import '../../utils/index.dart';
import '../../component/text_field.dart';
import '../home_ledger_tab/home_ledger_tab_logic.dart';

class HomeLedgerSettingsLogic extends GetxController {
  final db = HomeLedgerDatabase();

  final incomeCategoryCount = 0.obs;
  final expenseCategoryCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategoryCounts();
  }

  Future<void> _loadCategoryCounts() async {
    try {
      final incomeCategories = await db.getCategoriesByType('income');
      final expenseCategories = await db.getCategoriesByType('expense');

      incomeCategoryCount.value = incomeCategories.length;
      expenseCategoryCount.value = expenseCategories.length;
    } catch (e) {
      errorToast('Failed to load category counts');
    }
  }

  Future<void> backupData() async {
    try {
      final data = await db.exportAllData();

      
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'home_ledger_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonString);

      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        _showBackupLocationDialog(file.path);
      } else {
        try {
          
          await Share.shareXFiles([
            XFile(file.path),
          ], subject: 'HomeLedger Backup');
          successToast('Backup created and shared successfully');
        } catch (shareError) {
          _showBackupLocationDialog(file.path);
        }
      }
    } catch (e) {
      errorToast('Failed to backup data: ${e.toString()}');
    }
  }

  Future<void> restoreData() async {
    try {
      
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        await _showManualRestoreDialog();
        return;
      }

      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
      } catch (e) {
        await _showManualRestoreDialog();
        return;
      }

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = File(result.files.first.path!);

      final jsonString = await file.readAsString();

      
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Restore Data'),
          content: const Text(
            'This will overwrite all current data. Are you sure you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Restore'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      await db.importAllData(data);

      successToast('Data restored successfully');

      await _loadCategoryCounts();
      
      _refreshAllTabs();
    } catch (e) {
      errorToast('Failed to restore data: ${e.toString()}');
    }
  }

  Future<void> clearAllData() async {
    final firstConfirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your records. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Continue'),
          ),
        ],
      ),
    );

    if (firstConfirm != true) return;

    
    String deleteText = '';
    final secondConfirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type DELETE to confirm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            MyTextField(
              value: deleteText,
              onChange: (value) => deleteText = value,
              hintText: 'DELETE',
              border: const OutlineInputBorder(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (deleteText == 'DELETE') {
                Get.back(result: true);
              } else {
                errorToast('Please type DELETE to confirm');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (secondConfirm != true) return;

    try {
      await db.clearAllData();
      successToast('All data cleared successfully');

      await _loadCategoryCounts();
      
      _refreshAllTabs();
    } catch (e) {
      errorToast('Failed to clear data: ${e.toString()}');
    }
  }

  Future<void> refresh() async {
    await _loadCategoryCounts();
  }

  void _refreshAllTabs() {
    try {
      final tabLogic = Get.find<HomeLedgerTabLogic>();
      tabLogic.refreshAllTabs();
    } catch (e) {
      
    }
  }

  void _showBackupLocationDialog(String filePath) {
    Get.dialog(
      AlertDialog(
        title: const Text('Backup Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Backup file has been created successfully!'),
            const SizedBox(height: 16),
            const Text(
              'File location:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(
              filePath,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can manually share this file or copy it to your desired location.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _showManualRestoreDialog() async {
    String jsonContent = '';

    final result = await Get.dialog<String>(
      AlertDialog(
        title: const Text('Manual Restore'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'File picker is not available on this platform. Please paste the backup JSON content below:',
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: MyTextField(
                  value: jsonContent,
                  onChange: (value) => jsonContent = value,
                  hintText: 'Paste backup JSON content here...',
                  maxLines: null,
                  minLines: 8,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: jsonContent),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        
        final data = jsonDecode(result) as Map<String, dynamic>;

        final confirm = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Confirm Restore'),
            content: const Text(
              'This will replace all current data with the backup data. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
                child: const Text('Restore'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          await db.importAllData(data);
          successToast('Data restored successfully');

          await _loadCategoryCounts();
          
          _refreshAllTabs();
        }
      } catch (e) {
        errorToast('Invalid JSON format: ${e.toString()}');
      }
    }
  }
}
