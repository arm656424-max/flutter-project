enum QuestCategory { study, health, life }
enum QuestDifficulty { easy, medium, hard }

String categoryLabel(QuestCategory c) => switch (c) {
  QuestCategory.study => 'การเรียน',
  QuestCategory.health => 'สุขภาพ',
  QuestCategory.life => 'ชีวิตประจำวัน',
};

String difficultyLabel(QuestDifficulty d) => switch (d) {
  QuestDifficulty.easy => 'ง่าย',
  QuestDifficulty.medium => 'ปานกลาง',
  QuestDifficulty.hard => 'ยาก',
};

int difficultyExp(QuestDifficulty d) => switch (d) {
  QuestDifficulty.easy => 30,
  QuestDifficulty.medium => 50,
  QuestDifficulty.hard => 80,
};

class Quest {
  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    this.completed = false,
    this.completedAt,
  });

  final String id;
  String title;
  String description;
  QuestCategory category;
  QuestDifficulty difficulty;
  bool completed;
  DateTime? completedAt;
  int get exp => difficultyExp(difficulty);

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'category': category.name, 'difficulty': difficulty.name,
    'completed': completed, 'completedAt': completedAt?.toIso8601String(),
  };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
    id: json['id'] as String,
    title: json['title'] as String? ?? 'ภารกิจ',
    description: json['description'] as String? ?? '',
    category: QuestCategory.values.firstWhere((e) => e.name == json['category'], orElse: () => QuestCategory.life),
    difficulty: QuestDifficulty.values.firstWhere((e) => e.name == json['difficulty'], orElse: () => QuestDifficulty.easy),
    completed: json['completed'] as bool? ?? false,
    completedAt: json['completedAt'] == null ? null : DateTime.tryParse(json['completedAt'] as String),
  );
}
