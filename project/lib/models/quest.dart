enum QuestType { normal, daily, weekly }

class Quest {
  final String id;
  final String title;
  final String description;
  final int expReward;
  final int goldReward;
  final String statType; // STR, INT, VIT
  final QuestType questType;
  bool isCompleted;
  DateTime? completedAt;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.expReward,
    required this.goldReward,
    required this.statType,
    this.questType = QuestType.normal,
    this.isCompleted = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'expReward': expReward,
        'goldReward': goldReward,
        'statType': statType,
        'questType': questType.index,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Quest',
      description: json['description'] as String? ?? '',
      expReward: (json['expReward'] as num?)?.toInt() ?? 50,
      goldReward: (json['goldReward'] as num?)?.toInt() ?? 20,
      statType: json['statType'] as String? ?? 'STR',
      questType: json['questType'] != null
          ? QuestType.values[(json['questType'] as num).toInt() % QuestType.values.length]
          : QuestType.normal,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
    );
  }
}