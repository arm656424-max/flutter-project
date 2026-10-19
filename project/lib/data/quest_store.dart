import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest.dart';
import '../models/user_profile.dart';
import '../models/shop_item.dart';
import '../models/boss.dart';

class QuestStore extends ChangeNotifier {
  static const String _storageKey = 'questlife_solo_v6';

  UserProfile profile = UserProfile();
  List<Quest> quests = [];
  List<ShopItem> inventory = [];
  Boss boss = Boss(name: 'Blood-Red Commander Igris', currentHp: 500, maxHp: 500, rewardExp: 500, rewardGold: 300);

  final List<ShopItem> availableShopItems = [
    ShopItem(id: 'i1', name: 'Elixir of Life', description: '+100 EXP Instantly', price: 50, type: ItemType.expPotion, boostValue: 100),
    ShopItem(id: 'i2', name: "Knight's Dagger", description: '+10 STR Attack Power', price: 150, type: ItemType.weapon, boostValue: 10),
    ShopItem(id: 'i3', name: 'Demon Monarch Armor', description: '+20 VIT Defense Power', price: 300, type: ItemType.armor, boostValue: 20),
  ];

  QuestStore() {
    loadData();
  }

  void _initDefaultQuests() {
    quests = [
      Quest(id: 'q1', title: 'วิดพื้น 100 ครั้ง (Push-ups)', description: 'ภารกิจประจำวันเพื่อความแข็งแกร่ง', expReward: 100, goldReward: 50, statType: 'STR', questType: QuestType.daily),
      Quest(id: 'q2', title: 'ลุกนั่ง 100 ครั้ง (Sit-ups)', description: 'เพิ่มค่าความอึดของร่างกาย', expReward: 100, goldReward: 50, statType: 'VIT', questType: QuestType.daily),
      Quest(id: 'q3', title: 'อ่านหนังสือ 30 นาที', description: 'เพิ่มค่าความรู้และสติปัญญา', expReward: 100, goldReward: 50, statType: 'INT', questType: QuestType.daily),
      Quest(id: 'q4', title: 'เคลียร์ภารกิจสัปดาห์', description: 'ภารกิจใหญ่ประจำสัปดาห์', expReward: 300, goldReward: 150, statType: 'STR', questType: QuestType.weekly),
    ];
  }

  // ระบบตรวจสอบวันที่ และรีเซ็ตเควสเมื่อขึ้นวัน/สัปดาห์ใหม่
  void _checkAndResetQuests() {
    final now = DateTime.now();
    bool stateChanged = false;

    for (var quest in quests) {
      if (quest.isCompleted && quest.completedAt != null) {
        if (quest.questType == QuestType.daily) {
          // ตรวจสอบว่าวันที่ทำเสร็จ ไม่ใช่วันปัจจุบัน (คนละวัน/เดือน/ปี)
          final comp = quest.completedAt!;
          final isDifferentDay = now.year != comp.year || now.month != comp.month || now.day != comp.day;
          if (isDifferentDay) {
            quest.isCompleted = false;
            stateChanged = true;
          }
        } else if (quest.questType == QuestType.weekly) {
          // ตรวจสอบว่าทำเสร็จเกิน 7 วันแล้วหรือไม่
          final diffDays = now.difference(quest.completedAt!).inDays;
          if (diffDays >= 7) {
            quest.isCompleted = false;
            stateChanged = true;
          }
        }
      }
    }

    if (stateChanged) {
      saveData();
    }
  }

  void resetToDefaultQuests() {
    _initDefaultQuests();
    saveData();
    notifyListeners();
  }

  void updatePlayerName(String newName) {
    if (newName.trim().isNotEmpty) {
      profile.playerName = newName.trim();
      saveData();
      notifyListeners();
    }
  }

  void completeQuest(Quest quest) {
    if (quest.isCompleted) return;

    quest.isCompleted = true;
    quest.completedAt = DateTime.now();

    addExp(quest.expReward);
    profile.gold += quest.goldReward;

    if (quest.statType == 'STR') profile.strStat += 1;
    if (quest.statType == 'INT') profile.intStat += 1;
    if (quest.statType == 'VIT') profile.vitStat += 1;

    int totalDamage = 30 + profile.strStat;
    attackBoss(totalDamage);

    saveData();
    notifyListeners();
  }

  void addExp(int amount) {
    profile.exp += amount;
    while (profile.exp >= profile.maxExp) {
      profile.exp -= profile.maxExp;
      profile.level += 1;
      profile.strStat += 2;
      profile.intStat += 2;
      profile.vitStat += 2;

      if (profile.level >= 20 && profile.jobClass == 'Necromancer') {
        profile.jobClass = 'Shadow Monarch';
        profile.currentTitle = 'Monarch of Shadows';
      }
    }
  }

  void attackBoss(int damage) {
    if (boss.isDefeated) return;

    boss.currentHp -= damage;
    if (boss.currentHp <= 0) {
      boss.currentHp = 0;
      boss.isDefeated = true;
      addExp(boss.rewardExp);
      profile.gold += boss.rewardGold;
    }
  }

  void resetBoss() {
    int nextLevel = profile.level + 1;
    boss = Boss(
      name: 'Gate Guardian Lv.$nextLevel',
      currentHp: 500 + (profile.level * 100),
      maxHp: 500 + (profile.level * 100),
      rewardExp: 500 + (profile.level * 50),
      rewardGold: 300 + (profile.level * 30),
    );
    saveData();
    notifyListeners();
  }

  void buyItem(ShopItem item) {
    if (profile.gold >= item.price) {
      profile.gold -= item.price;
      inventory.add(item);
      saveData();
      notifyListeners();
    }
  }

  void useItem(ShopItem item) {
    if (item.type == ItemType.expPotion) {
      addExp(item.boostValue);
    } else if (item.type == ItemType.weapon) {
      profile.strStat += item.boostValue;
    } else if (item.type == ItemType.armor) {
      profile.vitStat += item.boostValue;
    }
    inventory.remove(item);
    saveData();
    notifyListeners();
  }

  void changeJobClass(String newClass) {
    profile.jobClass = newClass;
    saveData();
    notifyListeners();
  }

  void addQuest(Quest quest) {
    quests.add(quest);
    saveData();
    notifyListeners();
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'profile': profile.toJson(),
      'quests': quests.map((q) => q.toJson()).toList(),
      'inventory': inventory.map((i) => i.toJson()).toList(),
      'boss': boss.toJson(),
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_storageKey);
    if (rawJson != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(rawJson);
        if (data.containsKey('profile') && data['profile'] != null) {
          profile = UserProfile.fromJson(Map<String, dynamic>.from(data['profile']));
        }
        if (data.containsKey('quests') && data['quests'] != null) {
          quests = (data['quests'] as List)
              .map((e) => Quest.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
        if (data.containsKey('inventory') && data['inventory'] != null) {
          inventory = (data['inventory'] as List)
              .map((e) => ShopItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
        if (data.containsKey('boss') && data['boss'] != null) {
          boss = Boss.fromJson(Map<String, dynamic>.from(data['boss']));
        }

        if (quests.isEmpty) {
          _initDefaultQuests();
          await saveData();
        } else {
          // สั่งรีเซ็ตสถานะเควสเมื่อเข้าสู่วันใหม่
          _checkAndResetQuests();
        }

        notifyListeners();
        return;
      } catch (_) {}
    }
    _initDefaultQuests();
    await saveData();
    notifyListeners();
  }

  String exportToJson() => jsonEncode({
        'profile': profile.toJson(),
        'quests': quests.map((q) => q.toJson()).toList(),
        'inventory': inventory.map((i) => i.toJson()).toList(),
        'boss': boss.toJson(),
      });

  bool importFromJson(String jsonStr) {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonStr);
      if (data.containsKey('profile') && data['profile'] != null) {
        profile = UserProfile.fromJson(Map<String, dynamic>.from(data['profile']));
      }
      if (data.containsKey('quests') && data['quests'] != null) {
        quests = (data['quests'] as List)
            .map((e) => Quest.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (data.containsKey('inventory') && data['inventory'] != null) {
        inventory = (data['inventory'] as List)
            .map((e) => ShopItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      if (data.containsKey('boss') && data['boss'] != null) {
        boss = Boss.fromJson(Map<String, dynamic>.from(data['boss']));
      }
      
      if (quests.isEmpty) {
        _initDefaultQuests();
      } else {
        _checkAndResetQuests();
      }

      saveData();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }
}