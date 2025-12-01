import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'db_home_ledger_entity.dart';

class HomeLedgerDatabase {
  static final HomeLedgerDatabase _instance = HomeLedgerDatabase._internal();
  static Database? _database;

  factory HomeLedgerDatabase() => _instance;

  HomeLedgerDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'home_ledger.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE family (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        family_name TEXT NOT NULL DEFAULT 'My Home',
        member_count INTEGER NOT NULL DEFAULT 0,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE member (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        member_name TEXT NOT NULL,
        avatar TEXT,
        role TEXT NOT NULL DEFAULT 'member',
        join_time TEXT NOT NULL,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_name TEXT NOT NULL,
        category_name_cn TEXT,
        category_icon TEXT NOT NULL,
        type TEXT NOT NULL,
        is_system INTEGER NOT NULL DEFAULT 0,
        is_enabled INTEGER NOT NULL DEFAULT 1,
        sort_order INTEGER NOT NULL DEFAULT 0,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE record (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        note TEXT,
        member_id INTEGER NOT NULL,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL,
        FOREIGN KEY (category_id) REFERENCES category (id),
        FOREIGN KEY (member_id) REFERENCES member (id)
      )
    ''');

    await db.execute('CREATE INDEX idx_record_date ON record(date)');
    await db.execute('CREATE INDEX idx_record_type ON record(type)');
    await db.execute('CREATE INDEX idx_record_member ON record(member_id)');
    await db.execute('CREATE INDEX idx_record_category ON record(category_id)');

    await db.execute('''
      CREATE TABLE income_target (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monthly_target REAL NOT NULL,
        month TEXT NOT NULL UNIQUE,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE expense_budget (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monthly_budget REAL NOT NULL,
        month TEXT NOT NULL UNIQUE,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE app_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        current_user_id TEXT,
        language TEXT DEFAULT 'en',
        currency TEXT DEFAULT '\$',
        theme TEXT,
        notification_enabled INTEGER NOT NULL DEFAULT 1,
        create_time TEXT NOT NULL,
        update_time TEXT NOT NULL
      )
    ''');

    await _initDefaultData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _initDefaultData(Database db) async {
    final now = DateTime.now().toIso8601String();

    await db.insert('family', {
      'family_name': 'My Home',
      'member_count': 0,
      'create_time': now,
      'update_time': now,
    });

    await db.insert('member', {
      'member_name': 'Me',
      'role': 'admin',
      'join_time': now,
      'create_time': now,
      'update_time': now,
    });

    final incomeCategories = [
      {'name': 'Salary', 'nameCN': 'Salary', 'icon': '💰', 'order': 1},
      {
        'name': 'Business Income',
        'nameCN': 'Business Income',
        'icon': '💼',
        'order': 2,
      },
      {
        'name': 'Investment Returns',
        'nameCN': 'Investment Returns',
        'icon': '📈',
        'order': 3,
      },
      {'name': 'Bonus', 'nameCN': 'Bonus', 'icon': '🏆', 'order': 4},
      {'name': 'Gift Money', 'nameCN': 'Gift Money', 'icon': '🧧', 'order': 5},
      {
        'name': 'Other Income',
        'nameCN': 'Other Income',
        'icon': '📝',
        'order': 6,
      },
    ];

    for (var category in incomeCategories) {
      await db.insert('category', {
        'category_name': category['name'],
        'category_name_cn': category['nameCN'],
        'category_icon': category['icon'],
        'type': 'income',
        'is_system': 1,
        'is_enabled': 1,
        'sort_order': category['order'],
        'create_time': now,
        'update_time': now,
      });
    }

    final expenseCategories = [
      {'name': 'Food', 'nameCN': 'Food', 'icon': '🍔', 'order': 1},
      {'name': 'Clothing', 'nameCN': 'Clothing', 'icon': '👕', 'order': 2},
      {
        'name': 'Transportation',
        'nameCN': 'Transportation',
        'icon': '🚗',
        'order': 3,
      },
      {'name': 'Housing', 'nameCN': 'Housing', 'icon': '🏠', 'order': 4},
      {
        'name': 'Communication',
        'nameCN': 'Communication',
        'icon': '📱',
        'order': 5,
      },
      {
        'name': 'Daily Necessities',
        'nameCN': 'Daily Necessities',
        'icon': '🧻',
        'order': 6,
      },
      {
        'name': 'Pocket Money',
        'nameCN': 'Pocket Money',
        'icon': '💰',
        'order': 7,
      },
      {'name': 'Social', 'nameCN': 'Social', 'icon': '👥', 'order': 8},
      {'name': 'Education', 'nameCN': 'Education', 'icon': '📚', 'order': 9},
      {
        'name': 'Pets & Plants',
        'nameCN': 'Pets & Plants',
        'icon': '🐕',
        'order': 10,
      },
      {
        'name': 'Investment & Insurance',
        'nameCN': 'Investment & Insurance',
        'icon': '🛡️',
        'order': 11,
      },
      {
        'name': 'Entertainment',
        'nameCN': 'Entertainment',
        'icon': '🎡',
        'order': 12,
      },
      {
        'name': 'Digital Products',
        'nameCN': 'Digital Products',
        'icon': '📱',
        'order': 13,
      },
      {'name': 'Healthcare', 'nameCN': 'Healthcare', 'icon': '⚕️', 'order': 14},
      {
        'name': 'Other Expenses',
        'nameCN': 'Other Expenses',
        'icon': '📝',
        'order': 15,
      },
    ];

    for (var category in expenseCategories) {
      await db.insert('category', {
        'category_name': category['name'],
        'category_name_cn': category['nameCN'],
        'category_icon': category['icon'],
        'type': 'expense',
        'is_system': 1,
        'is_enabled': 1,
        'sort_order': category['order'],
        'create_time': now,
        'update_time': now,
      });
    }

    await db.insert('app_settings', {
      'current_user_id': '1',
      'language': 'en',
      'currency': '\$',
      'notification_enabled': 1,
      'create_time': now,
      'update_time': now,
    });
  }

  Future<FamilyEntity?> getFamily() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('family', limit: 1);

    if (maps.isEmpty) return null;
    return FamilyEntity.fromMap(maps.first);
  }

  Future<int> updateFamily(FamilyEntity family) async {
    final db = await database;
    family.updateTime = DateTime.now();
    return await db.update(
      'family',
      family.toMap(),
      where: 'id = ?',
      whereArgs: [family.id],
    );
  }

  Future<int> insertMember(MemberEntity member) async {
    final db = await database;
    member.createTime = DateTime.now();
    member.updateTime = DateTime.now();
    member.joinTime = DateTime.now();

    final id = await db.insert('member', member.toMap());

    await _updateMemberCount();

    return id;
  }

  Future<List<MemberEntity>> getAllMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'member',
      orderBy: 'join_time ASC',
    );

    return List.generate(maps.length, (i) => MemberEntity.fromMap(maps[i]));
  }

  Future<MemberEntity?> getMemberById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'member',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return MemberEntity.fromMap(maps.first);
  }

  Future<int> updateMember(MemberEntity member) async {
    final db = await database;
    member.updateTime = DateTime.now();
    return await db.update(
      'member',
      member.toMap(),
      where: 'id = ?',
      whereArgs: [member.id],
    );
  }

  Future<int> deleteMember(int id) async {
    final db = await database;
    final result = await db.delete('member', where: 'id = ?', whereArgs: [id]);

    await _updateMemberCount();

    return result;
  }

  Future<void> _updateMemberCount() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM member'),
        ) ??
        0;

    await db.update('family', {
      'member_count': count,
      'update_time': DateTime.now().toIso8601String(),
    }, where: 'id = 1');
  }

  Future<int> insertCategory(CategoryEntity category) async {
    final db = await database;
    category.createTime = DateTime.now();
    category.updateTime = DateTime.now();
    return await db.insert('category', category.toMap());
  }

  Future<List<CategoryEntity>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      orderBy: 'type ASC, sort_order ASC',
    );

    return List.generate(maps.length, (i) => CategoryEntity.fromMap(maps[i]));
  }

  Future<List<CategoryEntity>> getCategoriesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'type = ? AND is_enabled = 1',
      whereArgs: [type],
      orderBy: 'sort_order ASC',
    );

    return List.generate(maps.length, (i) => CategoryEntity.fromMap(maps[i]));
  }

  Future<List<CategoryEntity>> getAllCategoriesByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'sort_order ASC',
    );

    return List.generate(maps.length, (i) => CategoryEntity.fromMap(maps[i]));
  }

  Future<CategoryEntity?> getCategoryById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'category',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return CategoryEntity.fromMap(maps.first);
  }

  Future<int> updateCategory(CategoryEntity category) async {
    final db = await database;
    category.updateTime = DateTime.now();
    return await db.update(
      'category',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'category',
      where: 'id = ? AND is_system = 0',
      whereArgs: [id],
    );
  }

  Future<bool> isCategoryNameExists(
    String name,
    String type, {
    int? excludeId,
  }) async {
    final db = await database;
    String whereClause = 'category_name = ? AND type = ?';
    List<dynamic> whereArgs = [name, type];

    if (excludeId != null) {
      whereClause += ' AND id != ?';
      whereArgs.add(excludeId);
    }

    final count =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM category WHERE $whereClause',
            whereArgs,
          ),
        ) ??
        0;

    return count > 0;
  }

  Future<int> insertRecord(RecordEntity record) async {
    final db = await database;
    record.createTime = DateTime.now();
    record.updateTime = DateTime.now();
    return await db.insert('record', record.toMap());
  }

  Future<List<RecordEntity>> getAllRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      orderBy: 'date DESC, time DESC',
    );

    return List.generate(maps.length, (i) => RecordEntity.fromMap(maps[i]));
  }

  Future<List<RecordEntity>> getRecordsByMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'date LIKE ?',
      whereArgs: ['$month%'],
      orderBy: 'date DESC, time DESC',
    );

    return List.generate(maps.length, (i) => RecordEntity.fromMap(maps[i]));
  }

  Future<List<RecordEntity>> getRecordsByDateRange(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC, time DESC',
    );

    return List.generate(maps.length, (i) => RecordEntity.fromMap(maps[i]));
  }

  Future<List<RecordEntity>> getRecordsByMemberId(int memberId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'record',
      where: 'member_id = ?',
      whereArgs: [memberId],
      orderBy: 'date DESC, time DESC',
    );

    return List.generate(maps.length, (i) => RecordEntity.fromMap(maps[i]));
  }

  Future<int> updateRecord(RecordEntity record) async {
    final db = await database;
    record.updateTime = DateTime.now();
    return await db.update(
      'record',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete('record', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getMonthlyIncome(String month) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM record WHERE date LIKE ? AND type = ?',
      ['$month%', 'income'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getMonthlyExpense(String month) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM record WHERE date LIKE ? AND type = ?',
      ['$month%', 'expense'],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalSavings() async {
    final db = await database;

    final incomeResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM record WHERE type = ?',
      ['income'],
    );
    final totalIncome =
        (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;

    final expenseResult = await db.rawQuery(
      'SELECT SUM(amount) as total FROM record WHERE type = ?',
      ['expense'],
    );
    final totalExpense =
        (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return totalIncome - totalExpense;
  }

  Future<Map<int, double>> getAmountByCategory(
    String type,
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT category_id, SUM(amount) as total FROM record WHERE type = ? AND date BETWEEN ? AND ? GROUP BY category_id',
      [type, startDate, endDate],
    );

    Map<int, double> result = {};
    for (var map in maps) {
      result[map['category_id'] as int] = (map['total'] as num).toDouble();
    }

    return result;
  }

  Future<Map<int, double>> getExpenseByMember(
    String startDate,
    String endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT member_id, SUM(amount) as total FROM record WHERE type = ? AND date BETWEEN ? AND ? GROUP BY member_id',
      ['expense', startDate, endDate],
    );

    Map<int, double> result = {};
    for (var map in maps) {
      result[map['member_id'] as int] = (map['total'] as num).toDouble();
    }

    return result;
  }

  Future<int> setIncomeTarget(IncomeTargetEntity target) async {
    final db = await database;
    target.createTime = DateTime.now();
    target.updateTime = DateTime.now();

    final existing = await getIncomeTargetByMonth(target.month);
    if (existing != null) {
      target.id = existing.id;
      return await db.update(
        'income_target',
        target.toMap(),
        where: 'month = ?',
        whereArgs: [target.month],
      );
    } else {
      return await db.insert('income_target', target.toMap());
    }
  }

  Future<IncomeTargetEntity?> getIncomeTargetByMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'income_target',
      where: 'month = ?',
      whereArgs: [month],
    );

    if (maps.isEmpty) return null;
    return IncomeTargetEntity.fromMap(maps.first);
  }

  Future<int> setExpenseBudget(ExpenseBudgetEntity budget) async {
    final db = await database;
    budget.createTime = DateTime.now();
    budget.updateTime = DateTime.now();

    final existing = await getExpenseBudgetByMonth(budget.month);
    if (existing != null) {
      budget.id = existing.id;
      return await db.update(
        'expense_budget',
        budget.toMap(),
        where: 'month = ?',
        whereArgs: [budget.month],
      );
    } else {
      return await db.insert('expense_budget', budget.toMap());
    }
  }

  Future<ExpenseBudgetEntity?> getExpenseBudgetByMonth(String month) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expense_budget',
      where: 'month = ?',
      whereArgs: [month],
    );

    if (maps.isEmpty) return null;
    return ExpenseBudgetEntity.fromMap(maps.first);
  }

  Future<AppSettingsEntity?> getAppSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'app_settings',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return AppSettingsEntity.fromMap(maps.first);
  }

  Future<int> updateAppSettings(AppSettingsEntity settings) async {
    final db = await database;
    settings.updateTime = DateTime.now();
    return await db.update(
      'app_settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  Future<Map<String, dynamic>> exportAllData() async {
    final db = await database;

    return {
      'version': '1.0.0',
      'backupTime': DateTime.now().toIso8601String(),
      'data': {
        'family': await db.query('family'),
        'members': await db.query('member'),
        'categories': await db.query('category'),
        'records': await db.query('record'),
        'incomeTargets': await db.query('income_target'),
        'expenseBudgets': await db.query('expense_budget'),
        'settings': await db.query('app_settings'),
      },
    };
  }

  Future<void> importAllData(Map<String, dynamic> data) async {
    final db = await database;

    await clearAllData();

    final backupData = data['data'] as Map<String, dynamic>;

    if (backupData['family'] != null) {
      for (var item in backupData['family'] as List) {
        await db.insert('family', item);
      }
    }

    if (backupData['members'] != null) {
      for (var item in backupData['members'] as List) {
        await db.insert('member', item);
      }
    }

    if (backupData['categories'] != null) {
      for (var item in backupData['categories'] as List) {
        await db.insert('category', item);
      }
    }

    if (backupData['records'] != null) {
      for (var item in backupData['records'] as List) {
        await db.insert('record', item);
      }
    }

    if (backupData['incomeTargets'] != null) {
      for (var item in backupData['incomeTargets'] as List) {
        await db.insert('income_target', item);
      }
    }

    if (backupData['expenseBudgets'] != null) {
      for (var item in backupData['expenseBudgets'] as List) {
        await db.insert('expense_budget', item);
      }
    }

    if (backupData['settings'] != null) {
      for (var item in backupData['settings'] as List) {
        await db.insert('app_settings', item);
      }
    }
  }

  Future<void> clearAllData() async {
    final db = await database;

    await db.delete('record');
    await db.delete('income_target');
    await db.delete('expense_budget');
    await db.delete('member');
    await db.delete('category');
    await db.delete('family');
    await db.delete('app_settings');

    await _initDefaultData(db);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
