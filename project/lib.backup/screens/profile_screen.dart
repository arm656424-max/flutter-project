import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.store});
  final QuestStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
      const Text('ตัวละครของฉัน', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
      const Text('พัฒนาตัวเองทีละภารกิจ', style: TextStyle(color: kMuted)),
      const SizedBox(height: 18),
      Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [kPanel2, kPanel]), borderRadius: BorderRadius.circular(24), border: Border.all(color: kGold.withOpacity(.5)),), child: Column(children: [
        Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: kGold.withOpacity(.12), border: Border.all(color: kGold, width: 2)), child: const Icon(Icons.shield_moon_rounded, color: kGold, size: 60)),
        const SizedBox(height: 14),
        Text(store.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
        Text('RANK ${store.rank}  •  LEVEL ${store.level}', style: const TextStyle(color: kGold, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('EXP สะสม'), Text('${store.totalExp} EXP', style: const TextStyle(color: kBlue, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 8),
        ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: store.levelProgress, minHeight: 10, color: kGold, backgroundColor: kBg)),
      ])),
      const SizedBox(height: 20),
      const Text('ค่าสถานะ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
      const SizedBox(height: 10),
      _stat('INT', 'การเรียนรู้', store.studyDone, kBlue, Icons.auto_stories_rounded),
      _stat('STR', 'สุขภาพ', store.healthDone, kGreen, Icons.fitness_center_rounded),
      _stat('VIT', 'ชีวิตประจำวัน', store.lifeDone, kGold, Icons.bolt_rounded),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _mini('STREAK', '${store.streak} วัน', Icons.local_fire_department, const Color(0xFFFF8A4C))),
        const SizedBox(width: 10),
        Expanded(child: _mini('BEST', '${store.profile.bestStreak} วัน', Icons.emoji_events, kGold)),
      ]),
      const SizedBox(height: 12),
      const Card(child: ListTile(leading: Icon(Icons.phone_android, color: kBlue), title: Text('บันทึกในอุปกรณ์'), subtitle: Text('ข้อมูลจัดเก็บด้วย SharedPreferences โดยไม่ต้อง Login'))),
    ]),
  );

  Widget _stat(String code, String label, int value, Color color, IconData icon) => Card(child: ListTile(
    leading: CircleAvatar(backgroundColor: color.withOpacity(.13), child: Icon(icon, color: color)),
    title: Text('$code  •  $label', style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: (value / (value + 3)).clamp(0.0, 1.0).toDouble(), minHeight: 6, color: color, backgroundColor: kPanel2))),
    trailing: Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 18)),
  ));

  Widget _mini(String label, String value, IconData icon, Color color) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(16)), child: Row(children: [
    Icon(icon, color: color),
    const SizedBox(width: 8),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: kMuted, fontSize: 10)),
      Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 17)),
    ])),
  ]));
}
