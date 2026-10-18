import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest.dart';
import '../models/user_profile.dart';

class QuestStore extends ChangeNotifier {
  static const _questsKey = 'questlife_quests_v1';
  static const _expKey = 'questlife_total_exp_v1';
  static const _bonusKey = 'questlife_bonus_days_v1';
  static const _lastCompletedDayKey = 'questlife_last_completed_day_v1';
  static const _streakKey = 'questlife_streak_v1';
  static const _bestStreakKey = 'questlife_best_streak_v1';

  final List<Quest> quests = [];
  final UserProfile profile = UserProfile();
  final Set<String> claimedDailyBonuses = {};
  int streak = 0;
  String? lastCompletedDay;

  int get totalExp => profile.totalExp;
  int get level => profile.level;
  int get expInLevel => profile.expInLevel;
  double get levelProgress => profile.progress;
  String get title => profile.title;
  String get rank => profile.rank;
  int get completedCount => quests.where((q) => q.completed).length;
  int get activeCount => quests.where((q) => !q.completed).length;
  int get studyDone => quests
      .where((q) => q.completed && q.category == QuestCategory.study)
      .length;
  int get healthDone => quests
      .where((q) => q.completed && q.category == QuestCategory.health)
      .length;
  int get lifeDone => quests
      .where((q) => q.completed && q.category == QuestCategory.life)
      .length;

  String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';
  bool get dailyBonusClaimed =>
      claimedDailyBonuses.contains(_dayKey(DateTime.now()));

  int get completedToday => quests.where((q) {
        final d = q.completedAt;
        final n = DateTime.now();
        return q.completed &&
            d != null &&
            d.year == n.year &&
            d.month == n.month &&
            d.day == n.day;
      }).length;

  int _readInt(SharedPreferences prefs, String key, {int fallback = 0}) {
    // Read as Object first so stale/corrupt web preferences cannot crash the app.
    final value = prefs.get(key);
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  String? _readString(SharedPreferences prefs, String key) {
    final value = prefs.get(key);
    return value is String ? value : null;
  }

  List<String> _readStringList(SharedPreferences prefs, String key) {
    final value = prefs.get(key);
    if (value is List<String>) return value;
    if (value is List) return value.whereType<String>().toList();
    return <String>[];
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    profile.totalExp = _readInt(prefs, _expKey);
    streak = _readInt(prefs, _streakKey);
    profile.bestStreak = _readInt(prefs, _bestStreakKey);
    lastCompletedDay = _readString(prefs, _lastCompletedDayKey);
    claimedDailyBonuses.addAll(_readStringList(prefs, _bonusKey));
    final raw = _readString(prefs, _questsKey);
    if (raw != null) {
      try {
        final list = jsonDecode(raw) as List<dynamic>;
        quests.addAll(list
            .map((e) => Quest.fromJson(Map<String, dynamic>.from(e as Map))));
      } catch (_) {
        quests.clear();
      }
    }
    if (quests.isEmpty) {
      quests.addAll([
        Quest(
            id: 'seed1',
            title: 'อ่านหนังสือ 30 นาที',
            description: 'อ่านหรือทบทวนบทเรียนหนึ่งหัวข้อ',
            category: QuestCategory.study,
            difficulty: QuestDifficulty.medium),
        Quest(
            id: 'seed2',
            title: 'ขยับร่างกาย 20 นาที',
            description: 'เดินเร็ว ยืดเหยียด หรือออกกำลังกาย',
            category: QuestCategory.health,
            difficulty: QuestDifficulty.medium),
        Quest(
            id: 'seed3',
            title: 'จัดโต๊ะให้เรียบร้อย',
            description: 'เตรียมพื้นที่สำหรับภารกิจต่อไป',
            category: QuestCategory.life,
            difficulty: QuestDifficulty.easy),
      ]);
    }
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _questsKey, jsonEncode(quests.map((q) => q.toJson()).toList()));
    await prefs.setInt(_expKey, profile.totalExp);
    await prefs.setStringList(_bonusKey, claimedDailyBonuses.toList());
    await prefs.setInt(_streakKey, streak);
    await prefs.setInt(_bestStreakKey, profile.bestStreak);
    if (lastCompletedDay != null)
      await prefs.setString(_lastCompletedDayKey, lastCompletedDay!);
  }

  Future<void> addQuest(Quest q) async {
    quests.insert(0, q);
    await _save();
    notifyListeners();
  }

  Future<void> updateQuest(Quest q) async {
    final i = quests.indexWhere((x) => x.id == q.id);
    if (i < 0) return;
    quests[i]
      ..title = q.title
      ..description = q.description
      ..category = q.category
      ..difficulty = q.difficulty;
    await _save();
    notifyListeners();
  }

  Future<void> deleteQuest(String id) async {
    quests.removeWhere((q) => q.id == id);
    await _save();
    notifyListeners();
  }

  Future<bool> completeQuest(String id) async {
    final i = quests.indexWhere((q) => q.id == id);
    if (i < 0 || quests[i].completed) return false;

    final now = DateTime.now();
    final today = _dayKey(now);
    final yesterday = _dayKey(now.subtract(const Duration(days: 1)));
    if (lastCompletedDay == today) {
      // A streak day is counted once per calendar day, not per quest.
    } else if (lastCompletedDay == yesterday) {
      streak += 1;
    } else {
      streak = 1;
    }
    lastCompletedDay = today;
    if (streak > profile.bestStreak) profile.bestStreak = streak;

    quests[i]
      ..completed = true
      ..completedAt = now;
    profile.totalExp += quests[i].exp;
    await _save();
    notifyListeners();
    return true;
  }

  Future<bool> claimDailyBonus() async {
    final key = _dayKey(DateTime.now());
    if (claimedDailyBonuses.contains(key) || completedToday < 3) return false;
    claimedDailyBonuses.add(key);
    profile.totalExp += 100;
    await _save();
    notifyListeners();
    return true;
  }
}
