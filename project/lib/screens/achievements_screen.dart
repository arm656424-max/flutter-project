import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../main.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, required this.store});
  final QuestStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final badges = [
            _Badge(Icons.flag_rounded, 'ก้าวแรก', 'สำเร็จ 1 ภารกิจ',
                store.completedCount >= 1),
            _Badge(Icons.local_fire_department_rounded, 'วินัยเริ่มต้น',
                'ทำภารกิจต่อเนื่อง 3 วัน', store.streak >= 3),
            _Badge(Icons.military_tech_rounded, 'เครื่องจักรแห่งวินัย',
                'สำเร็จ 5 ภารกิจ', store.completedCount >= 5),
            _Badge(Icons.workspace_premium_rounded, 'นักสะสม EXP',
                'สะสม 300 EXP', store.totalExp >= 300),
            _Badge(Icons.school_rounded, 'นักเรียนรู้',
                'สำเร็จภารกิจการเรียน 3 ครั้ง', store.studyDone >= 3),
            _Badge(Icons.favorite_rounded, 'แข็งแกร่งขึ้น',
                'สำเร็จภารกิจสุขภาพ 3 ครั้ง', store.healthDone >= 3),
            _Badge(Icons.local_fire_department, 'เปลวไฟไม่ดับ',
                'ทำภารกิจต่อเนื่อง 7 วัน', store.streak >= 7),
            _Badge(Icons.stars_rounded, 'ตำนานผู้พิชิต', 'ไปถึงเลเวล 10',
                store.level >= 10),
          ];
          final unlocked = badges.where((b) => b.unlocked).length;
          return ListView(padding: const EdgeInsets.all(16), children: [
            Row(children: [
              const Expanded(
                  child: Text('หอเกียรติยศ',
                      style: TextStyle(
                          fontSize: 27, fontWeight: FontWeight.w900))),
              Text('$unlocked/${badges.length}',
                  style: const TextStyle(
                      color: kGold, fontWeight: FontWeight.w900)),
            ]),
            const Text('ปลดล็อกตราจากความสม่ำเสมอและความพยายาม',
                style: TextStyle(color: kMuted)),
            const SizedBox(height: 16),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                    value: unlocked / badges.length,
                    minHeight: 8,
                    color: kGold,
                    backgroundColor: kPanel2)),
            const SizedBox(height: 16),
            ...badges.map((b) => Card(
                    child: ListTile(
                  leading: CircleAvatar(
                      backgroundColor:
                          b.unlocked ? kGold.withOpacity(.14) : kPanel2,
                      child: Icon(b.icon, color: b.unlocked ? kGold : kMuted)),
                  title: Text(b.title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: b.unlocked ? Colors.white : kMuted)),
                  subtitle:
                      Text(b.detail, style: const TextStyle(color: kMuted)),
                  trailing: Icon(b.unlocked ? Icons.check_circle : Icons.lock,
                      color: b.unlocked ? kGreen : kMuted),
                ))),
          ]);
        },
      );
}

class _Badge {
  _Badge(this.icon, this.title, this.detail, this.unlocked);
  final IconData icon;
  final String title;
  final String detail;
  final bool unlocked;
}
