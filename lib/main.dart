import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_ledger/pages/home_ledger_add_record/home_ledger_add_record_binding.dart';
import 'package:home_ledger/pages/home_ledger_add_record/home_ledger_add_record_view.dart';
import 'package:home_ledger/pages/home_ledger_expense_categories/home_ledger_expense_categories_binding.dart';
import 'package:home_ledger/pages/home_ledger_expense_categories/home_ledger_expense_categories_view.dart';
import 'package:home_ledger/pages/home_ledger_income_categories/home_ledger_income_categories_binding.dart';
import 'package:home_ledger/pages/home_ledger_income_categories/home_ledger_income_categories_view.dart';
import 'package:home_ledger/pages/home_ledger_tab/home_ledger_tab_binding.dart';
import 'package:home_ledger/pages/home_ledger_tab/home_ledger_tab_view.dart';

Color primaryColor = const Color(0xFF3B82F6);
Color bgColor = const Color(0xFFF5F5F7);

List<GetPage<dynamic>> HomeBill = [
  GetPage(
    name: '/home_ledger_tab',
    page: () => const HomeLedgerTabView(),
    binding: HomeLedgerTabBinding(),
  ),
  GetPage(
    name: '/home_ledger_add_record',
    page: () => const HomeLedgerAddRecordView(),
    binding: HomeLedgerAddRecordBinding(),
  ),
  GetPage(
    name: '/home_ledger_income_categories',
    page: () => const HomeLedgerIncomeCategoriesView(),
    binding: HomeLedgerIncomeCategoriesBinding(),
  ),
  GetPage(
    name: '/home_ledger_expense_categories',
    page: () => const HomeLedgerExpenseCategoriesView(),
    binding: HomeLedgerExpenseCategoriesBinding(),
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: HomeBill,
          initialRoute: '/home_ledger_tab',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: bgColor,
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              surface: Color(0xFFFFFFFF),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              backgroundColor: Color(0xFF3B82F6),
              iconTheme: IconThemeData(size: 22, color: Colors.white),
              toolbarHeight: 46,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Color(0xFFC9743B),
              unselectedItemColor: Color(0xFF292929),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }
}

