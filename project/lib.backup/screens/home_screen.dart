import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../models/quest.dart';
import '../main.dart';
import 'quest_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store, required this.onNavigate});
  final QuestStore store;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) => ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
      children: [
        Row(children: [
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('QUESTLIFE', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: 1.8, color: kBlue)),
            SizedBox(height: 2),
            Text('ชีวิตจริง • ภารกิจจริง • เลเวลจริง', style: TextStyle(color: kMuted, fontSize: 12)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: kGold.withOpacity(.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: kGold.withOpacity(.5))),
            child: Text('RANK ${store.rank}', style: const TextStyle(color: kGold, fontWeight: FontWeight.w900)),
          ),
        ]),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(16), border: Border.all(color: kGold.withOpacity(.35))),
          child: const Row(children: [
            Icon(Icons.code_rounded, color: kGold),
            SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ผู้พัฒนา: เดชาวัต บุตรงาม', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('รหัสผู้พัฒนา: 016830641021-3', style: TextStyle(color: kMuted, fontSize: 12)),
            ])),
          ]),
        ),
        const SizedBox(height: 18),
        _heroCard(),
        const SizedBox(height: 20),
        Row(children: [
          const Expanded(child: Text('ภารกิจของคุณ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
          TextButton(onPressed: () => onNavigate(1), child: const Text('ดูทั้งหมด')),
        ]),
        ...store.quests.where((q) => !q.completed).take(3).map((q) => _questTile(context, q)),
        if (store.activeCount == 0)
          Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(16)), child: const Text('เคลียร์หมดแล้ว! ไปเพิ่มภารกิจใหม่เพื่อรับ EXP ต่อ')),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _stat('${store.completedCount}', 'สำเร็จ', kGreen, Icons.check_circle)),
          const SizedBox(width: 8),
          Expanded(child: _stat('${store.activeCount}', 'รอทำ', kBlue, Icons.flag)),
          const SizedBox(width: 8),
          Expanded(child: _stat('${store.streak}', 'วันต่อเนื่อง', kGold, Icons.local_fire_department)),
        ]),
        const SizedBox(height: 14),
        OutlinedButton.icon(onPressed: () => onNavigate(4), icon: const Icon(Icons.insights_rounded), label: const Text('ดูสถิติการเติบโต')),
      ],
    ),
  );

  Widget _heroCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kPanel2, kPanel, const Color(0xFF10182A)]),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: kGold.withOpacity(.55)),
      boxShadow: [BoxShadow(color: kBlue.withOpacity(.08), blurRadius: 24, spreadRadius: 1)],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: kGold.withOpacity(.13), border: Border.all(color: kGold.withOpacity(.8), width: 2)), child: const Icon(Icons.shield_moon_rounded, color: kGold, size: 35)),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(store.title, style: const TextStyle(color: kGold, fontWeight: FontWeight.bold)),
          Text('LEVEL ${store.level}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Text('TOTAL EXP', style: TextStyle(color: kMuted, fontSize: 10, letterSpacing: 1)),
          Text('${store.totalExp}', style: const TextStyle(color: kBlue, fontSize: 21, fontWeight: FontWeight.w900)),
        ]),
      ]),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('EXP ไปเลเวลถัดไป', style: TextStyle(color: kMuted, fontSize: 12)),
        Text('${store.expInLevel}/100', style: const TextStyle(color: kGold, fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 8),
      ClipRRect(borderRadius: BorderRadius.circular(30), child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: store.levelProgress),
        duration: const Duration(milliseconds: 700),
        builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 11, backgroundColor: kBg, color: kGold),
      )),
      const SizedBox(height: 14),
      Row(children: [
        const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF8A4C), size: 20),
        const SizedBox(width: 6),
        Text('Streak ${store.streak} วัน', style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text('สถิติสูงสุด ${store.profile.bestStreak} วัน', style: const TextStyle(color: kMuted, fontSize: 11)),
      ]),
    ]),
  );

  Widget _questTile(BuildContext context, Quest q) => Card(
    child: ListTile(
      leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: kBlue.withOpacity(.12), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.flag_rounded, color: kBlue)),
      title: Text(q.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text('${categoryLabel(q.category)} • +${q.exp} EXP', style: const TextStyle(color: kMuted, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right_rounded, color: kGold),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestDetailScreen(store: store, questId: q.id))),
    ),
  );

  Widget _stat(String value, String label, Color color, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
    decoration: BoxDecoration(color: kPanel, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(.2))),
    child: Column(children: [
      Icon(icon, color: color, size: 19),
      const SizedBox(height: 7),
      Text(value, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: color)),
      Text(label, style: const TextStyle(fontSize: 10, color: kMuted), textAlign: TextAlign.center),
    ]),
  );
}
