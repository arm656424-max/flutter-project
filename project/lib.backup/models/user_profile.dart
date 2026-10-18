class UserProfile {
  UserProfile({this.name = 'นักผจญภัย', this.totalExp = 0, this.bestStreak = 0});
  String name;
  int totalExp;
  int bestStreak;

  int get level => totalExp ~/ 100 + 1;
  int get expInLevel => totalExp % 100;
  double get progress => expInLevel / 100;

  String get title {
    if (level >= 20) return 'ตำนานแห่ง QuestLife';
    if (level >= 10) return 'ผู้พิชิต';
    if (level >= 5) return 'นักผจญภัยชั้นสูง';
    if (level >= 3) return 'นักผจญภัย';
    return 'ผู้เริ่มต้น';
  }

  String get rank {
    if (level >= 20) return 'S';
    if (level >= 10) return 'A';
    if (level >= 5) return 'B';
    if (level >= 3) return 'C';
    return 'D';
  }
}
