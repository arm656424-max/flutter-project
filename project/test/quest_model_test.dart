import 'package:flutter_test/flutter_test.dart';
import 'package:questlife/models/quest.dart';
import 'package:questlife/models/user_profile.dart';

void main() {
  group('Quest JSON compatibility', () {
    test('handles null and incorrectly typed legacy values safely', () {
      final quest = Quest.fromJson({
        'id': null,
        'title': 42,
        'description': null,
        'category': null,
        'difficulty': 'unknown',
        'completed': null,
        'completedAt': 123,
      });

      expect(quest.id, isNotEmpty);
      expect(quest.title, 'ภารกิจ');
      expect(quest.description, '');
      expect(quest.category, QuestCategory.life);
      expect(quest.difficulty, QuestDifficulty.easy);
      expect(quest.completed, isFalse);
      expect(quest.completedAt, isNull);
    });

    test('round-trips a valid quest', () {
      final quest = Quest(
        id: 'test-1',
        title: 'อ่านหนังสือ',
        description: 'อ่าน 20 นาที',
        category: QuestCategory.study,
        difficulty: QuestDifficulty.medium,
      );
      final restored = Quest.fromJson(quest.toJson());
      expect(restored.id, quest.id);
      expect(restored.title, quest.title);
      expect(restored.category, QuestCategory.study);
      expect(restored.exp, 50);
    });
  });

  test('level and EXP progress remain consistent', () {
    final profile = UserProfile(totalExp: 250);
    expect(profile.level, 3);
    expect(profile.expInLevel, 50);
    expect(profile.progress, 0.5);
  });
}
