
class FamilyEntity {
  int? id;
  String familyName;
  int memberCount;
  DateTime? createTime;
  DateTime? updateTime;

  FamilyEntity({
    this.id,
    required this.familyName,
    this.memberCount = 0,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'family_name': familyName,
      'member_count': memberCount,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory FamilyEntity.fromMap(Map<String, dynamic> map) {
    return FamilyEntity(
      id: map['id'] as int?,
      familyName: map['family_name'] as String,
      memberCount: map['member_count'] as int,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

class MemberEntity {
  int? id;
  String memberName;
  String? avatar;
  String role;
  DateTime? joinTime;
  DateTime? createTime;
  DateTime? updateTime;

  MemberEntity({
    this.id,
    required this.memberName,
    this.avatar,
    this.role = 'member',
    this.joinTime,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'member_name': memberName,
      'avatar': avatar,
      'role': role,
      'join_time': joinTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory MemberEntity.fromMap(Map<String, dynamic> map) {
    return MemberEntity(
      id: map['id'] as int?,
      memberName: map['member_name'] as String,
      avatar: map['avatar'] as String?,
      role: map['role'] as String,
      joinTime: map['join_time'] != null ? DateTime.parse(map['join_time'] as String) : null,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

class CategoryEntity {
  int? id;
  String categoryName;
  String? categoryNameCN;
  String categoryIcon;
  String type;
  bool isSystem;
  bool isEnabled;
  int sortOrder;
  DateTime? createTime;
  DateTime? updateTime;

  CategoryEntity({
    this.id,
    required this.categoryName,
    this.categoryNameCN,
    required this.categoryIcon,
    required this.type,
    this.isSystem = false,
    this.isEnabled = true,
    this.sortOrder = 0,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': categoryName,
      'category_name_cn': categoryNameCN,
      'category_icon': categoryIcon,
      'type': type,
      'is_system': isSystem ? 1 : 0,
      'is_enabled': isEnabled ? 1 : 0,
      'sort_order': sortOrder,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'] as int?,
      categoryName: map['category_name'] as String,
      categoryNameCN: map['category_name_cn'] as String?,
      categoryIcon: map['category_icon'] as String,
      type: map['type'] as String,
      isSystem: (map['is_system'] as int) == 1,
      isEnabled: (map['is_enabled'] as int) == 1,
      sortOrder: map['sort_order'] as int,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

class RecordEntity {
  int? id;
  String type;
  int categoryId;
  double amount;
  String date;
  String time;
  String? note;
  int memberId;
  DateTime? createTime;
  DateTime? updateTime;

  RecordEntity({
    this.id,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.time,
    this.note,
    required this.memberId,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category_id': categoryId,
      'amount': amount,
      'date': date,
      'time': time,
      'note': note,
      'member_id': memberId,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory RecordEntity.fromMap(Map<String, dynamic> map) {
    return RecordEntity(
      id: map['id'] as int?,
      type: map['type'] as String,
      categoryId: map['category_id'] as int,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      time: map['time'] as String,
      note: map['note'] as String?,
      memberId: map['member_id'] as int,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }

  double get displayAmount {
    return type == 'income' ? amount : -amount;
  }
}

class IncomeTargetEntity {
  int? id;
  double monthlyTarget;
  String month;
  DateTime? createTime;
  DateTime? updateTime;

  IncomeTargetEntity({
    this.id,
    required this.monthlyTarget,
    required this.month,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monthly_target': monthlyTarget,
      'month': month,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory IncomeTargetEntity.fromMap(Map<String, dynamic> map) {
    return IncomeTargetEntity(
      id: map['id'] as int?,
      monthlyTarget: (map['monthly_target'] as num).toDouble(),
      month: map['month'] as String,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

class ExpenseBudgetEntity {
  int? id;
  double monthlyBudget;
  String month;
  DateTime? createTime;
  DateTime? updateTime;

  ExpenseBudgetEntity({
    this.id,
    required this.monthlyBudget,
    required this.month,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monthly_budget': monthlyBudget,
      'month': month,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory ExpenseBudgetEntity.fromMap(Map<String, dynamic> map) {
    return ExpenseBudgetEntity(
      id: map['id'] as int?,
      monthlyBudget: (map['monthly_budget'] as num).toDouble(),
      month: map['month'] as String,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

class AppSettingsEntity {
  int? id;
  String? currentUserId;
  String? language;
  String? currency;
  String? theme;
  bool notificationEnabled;
  DateTime? createTime;
  DateTime? updateTime;

  AppSettingsEntity({
    this.id,
    this.currentUserId,
    this.language = 'en',
    this.currency = '\$',
    this.theme,
    this.notificationEnabled = true,
    this.createTime,
    this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'current_user_id': currentUserId,
      'language': language,
      'currency': currency,
      'theme': theme,
      'notification_enabled': notificationEnabled ? 1 : 0,
      'create_time': createTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'update_time': updateTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory AppSettingsEntity.fromMap(Map<String, dynamic> map) {
    return AppSettingsEntity(
      id: map['id'] as int?,
      currentUserId: map['current_user_id'] as String?,
      language: map['language'] as String?,
      currency: map['currency'] as String?,
      theme: map['theme'] as String?,
      notificationEnabled: (map['notification_enabled'] as int) == 1,
      createTime: map['create_time'] != null ? DateTime.parse(map['create_time'] as String) : null,
      updateTime: map['update_time'] != null ? DateTime.parse(map['update_time'] as String) : null,
    );
  }
}

