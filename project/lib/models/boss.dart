class Boss {
  final String name;
  int currentHp;
  final int maxHp;
  final int rewardExp;
  final int rewardGold;
  bool isDefeated;

  Boss({
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.rewardExp,
    required this.rewardGold,
    this.isDefeated = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'currentHp': currentHp,
        'maxHp': maxHp,
        'rewardExp': rewardExp,
        'rewardGold': rewardGold,
        'isDefeated': isDefeated,
      };

  factory Boss.fromJson(Map<String, dynamic> json) {
    return Boss(
      name: json['name'] as String? ?? 'Blood-Red Commander Igris',
      currentHp: (json['currentHp'] as num?)?.toInt() ?? 500,
      maxHp: (json['maxHp'] as num?)?.toInt() ?? 500,
      rewardExp: (json['rewardExp'] as num?)?.toInt() ?? 500,
      rewardGold: (json['rewardGold'] as num?)?.toInt() ?? 300,
      isDefeated: json['isDefeated'] as bool? ?? false,
    );
  }
}