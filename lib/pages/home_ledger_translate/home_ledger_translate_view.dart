import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_ledger_translate_logic.dart';

class HomeLedgerTranslateView extends GetView<HomeLedgerTranslateLogic> {
  const HomeLedgerTranslateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.snwz.value
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.oknbgfd();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
