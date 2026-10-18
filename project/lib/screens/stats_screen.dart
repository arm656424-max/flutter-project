import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../main.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.store});
  final QuestStore store;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final total = store.quests.length;
          final rate = total == 0 ? 0.0 : store.completedCount / total;
          return ListView(padding: const EdgeInsets.all(16), children: [
            const Text('สถิติการเติบโต',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
            const Text('ทุกภารกิจคือหลักฐานของการพัฒนา',
                style: TextStyle(color: kMuted)),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(
                  child: _tile(
                      '${store.totalExp}', 'EXP สะสม', kGold, Icons.bolt)),
              const SizedBox(width: 8),
              Expanded(
                  child: _tile('${store.completedCount}', 'สำเร็จ', kGreen,
                      Icons.check_circle)),
              const SizedBox(width: 8),
              Expanded(
                  child: _tile('${store.streak}', 'Streak', kBlue,
                      Icons.local_fire_department)),
            ]),
            const SizedBox(height: 16),
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('อัตราความสำเร็จ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('${(rate * 100).round()}%',
                              style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: kGold)),
                          Text('${store.completedCount} จาก $total ภารกิจ',
                              style: const TextStyle(color: kMuted)),
                          const SizedBox(height: 12),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                  value: rate,
                                  minHeight: 10,
                                  color: kGold,
                                  backgroundColor: kPanel2)),
                        ]))),
            const SizedBox(height: 20),
            const Text('ภารกิจสำเร็จแยกตามหมวด',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            _bar('การเรียน', store.studyDone, kBlue, Icons.menu_book),
            _bar('สุขภาพ', store.healthDone, kGreen, Icons.fitness_center),
            _bar('ชีวิตประจำวัน', store.lifeDone, kGold, Icons.auto_awesome),
            const SizedBox(height: 16),
            Card(
                child: ListTile(
              leading: const Icon(Icons.today_rounded, color: kBlue),
              title: const Text('ภารกิจที่สำเร็จวันนี้'),
              subtitle: Text(
                  '${store.completedToday} ภารกิจ • โบนัส +100 EXP เมื่อครบ 3 ภารกิจ'),
              trailing: store.completedToday >= 3 && !store.dailyBonusClaimed
                  ? FilledButton(
                      onPressed: () async {
                        final ok = await store.claimDailyBonus();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(ok
                                ? 'รับโบนัส +100 EXP แล้ว!'
                                : 'รับโบนัสไม่ได้')));
                      },
                      child: const Text('รับโบนัส'))
                  : Icon(
                      store.dailyBonusClaimed
                          ? Icons.check_circle
                          : Icons.lock_outline,
                      color: store.dailyBonusClaimed ? kGreen : kMuted),
            )),
            const SizedBox(height: 12),
            Card(
                child: ListTile(
              leading: const Icon(Icons.emoji_events_rounded, color: kGold),
              title: const Text('สถิติ Streak สูงสุด'),
              trailing: Text('${store.profile.bestStreak} วัน',
                  style: const TextStyle(
                      color: kGold, fontWeight: FontWeight.w900)),
            )),
          ]);
        },
      );

  Widget _tile(String value, String label, Color color, IconData icon) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
            color: kPanel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(.2))),
        child: Column(children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          Text(label, style: const TextStyle(fontSize: 10, color: kMuted)),
        ]),
      );

  Widget _bar(String label, int value, Color color, IconData icon) {
    final progress = (value / (value + 3)).clamp(0.0, 1.0).toDouble();
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          SizedBox(
              width: 105,
              child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      color: color,
                      backgroundColor: kPanel2))),
          const SizedBox(width: 10),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]));
  }
}
