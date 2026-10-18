class UserProfile {
  String playerName; // ชื่อผู้เล่น (แก้ไขได้)
  final String developerName; // ชื่อผู้พัฒนา (คงที่)
  final String studentId; // รหัสนักศึกษา (คงที่)
  int level;
  int exp;
  int gold;
  int streak;
  int maxStreak;
  String jobClass;
  String currentTitle;

  int strStat;
  int intStat;
  int vitStat;

  DateTime? lastActiveDate;

  UserProfile({
    this.playerName = 'Hunter',
    this.developerName = 'เดชาวัต บุตรงาม',
    this.studentId = '016830641021-3',
    this.level = 1,
    this.exp = 0,
    this.gold = 100,
    this.streak = 0,
    this.maxStreak = 0,
    this.jobClass = 'Shadow Monarch',
    this.currentTitle = 'Wolf Slayer',
    this.strStat = 10,
    this.intStat = 10,
    this.vitStat = 10,
    this.lastActiveDate,
  });

  int get maxExp => level * 100;

  String get rank {
    if (level >= 50) return 'S';
    if (level >= 35) return 'A';
    if (level >= 25) return 'B';
    if (level >= 15) return 'C';
    if (level >= 5) return 'D';
    return 'E';
  }

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'developerName': developerName,
        'studentId': studentId,
        'level': level,
        'exp': exp,
        'gold': gold,
        'streak': streak,
        'maxStreak': maxStreak,
        'jobClass': jobClass,
        'currentTitle': currentTitle,
        'strStat': strStat,
        'intStat': intStat,
        'vitStat': vitStat,
        'lastActiveDate': lastActiveDate?.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      playerName: json['playerName']?.toString() ?? json['name']?.toString() ?? 'Hunter',
      developerName: 'เดชาวัต บุตรงาม',
      studentId: '016830641021-3',
      level: (json['level'] as num?)?.toInt() ?? 1,
      exp: (json['exp'] as num?)?.toInt() ?? 0,
      gold: (json['gold'] as num?)?.toInt() ?? 100,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 0,
      jobClass: json['jobClass']?.toString() ?? 'Shadow Monarch',
      currentTitle: json['currentTitle']?.toString() ?? 'Wolf Slayer',
      strStat: (json['strStat'] as num?)?.toInt() ?? 10,
      intStat: (json['intStat'] as num?)?.toInt() ?? 10,
      vitStat: (json['vitStat'] as num?)?.toInt() ?? 10,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.tryParse(json['lastActiveDate'].toString())
          : null,
    );
  }
}