import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../main.dart';
import '../models/quest.dart';

class QuestDetailScreen extends StatelessWidget {
  const QuestDetailScreen(
      {super.key, required this.store, required this.questId});
  final QuestStore store;
  final String questId;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final found = store.quests.where((q) => q.id == questId);
          if (found.isEmpty)
            return const Scaffold(body: Center(child: Text('ไม่พบภารกิจ')));
          final q = found.first;
          return Scaffold(
            appBar: AppBar(title: const Text('รายละเอียดภารกิจ')),
            body: ListView(padding: const EdgeInsets.all(20), children: [
              Container(
                  height: 150,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        kBlue.withOpacity(.22),
                        kGold.withOpacity(.13)
                      ]),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: kGold.withOpacity(.3))),
                  child:
                      const Icon(Icons.flag_rounded, size: 68, color: kGold)),
              const SizedBox(height: 20),
              Text(q.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(
                  q.description.isEmpty
                      ? 'ไม่มีรายละเอียดเพิ่มเติม'
                      : q.description,
                  style: const TextStyle(color: kMuted, height: 1.5)),
              const SizedBox(height: 20),
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(children: [
                        _row('หมวดหมู่', categoryLabel(q.category)),
                        const Divider(height: 24),
                        _row('ความยาก', difficultyLabel(q.difficulty)),
                        const Divider(height: 24),
                        _row('รางวัล', '+${q.exp} EXP'),
                        const Divider(height: 24),
                        _row('สถานะ', q.completed ? 'สำเร็จแล้ว' : 'กำลังทำ'),
                      ]))),
              const SizedBox(height: 18),
              if (!q.completed)
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: kGold,
                      foregroundColor: kBg,
                      padding: const EdgeInsets.all(16)),
                  onPressed: () async {
                    final beforeLevel = store.level;
                    final ok = await store.completeQuest(q.id);
                    if (!context.mounted || !ok) return;
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (dialogContext) => _QuestCompleteDialog(
                        exp: q.exp,
                        levelUp: store.level > beforeLevel,
                        level: store.level,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('ทำภารกิจสำเร็จ'),
                )
              else
                const Card(
                    child: ListTile(
                        leading: Icon(Icons.verified, color: kGreen),
                        title: Text('รับรางวัลภารกิจนี้แล้ว'))),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () async {
                  final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: const Text('ลบภารกิจ?'),
                            content:
                                const Text('คุณต้องการลบภารกิจนี้ใช่หรือไม่'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('ยกเลิก')),
                              FilledButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('ลบ')),
                            ],
                          ));
                  if (ok == true) {
                    await store.deleteQuest(q.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: const Text('ลบภารกิจ',
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ]),
          );
        },
      );

  Widget _row(String label, String value) => Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: kMuted))),
        Text(value,
            style: const TextStyle(color: kGold, fontWeight: FontWeight.bold)),
      ]);
}

class _QuestCompleteDialog extends StatefulWidget {
  const _QuestCompleteDialog(
      {required this.exp, required this.levelUp, required this.level});
  final int exp;
  final bool levelUp;
  final int level;
  @override
  State<_QuestCompleteDialog> createState() => _QuestCompleteDialogState();
}

class _QuestCompleteDialogState extends State<_QuestCompleteDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900))
    ..forward();
  late final Animation<double> _scale =
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: kPanel,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: kGold.withOpacity(.7))),
        child: ScaleTransition(
          scale: _scale,
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                  widget.levelUp
                      ? Icons.workspace_premium_rounded
                      : Icons.check_circle_rounded,
                  color: kGold,
                  size: 68),
              const SizedBox(height: 12),
              Text(widget.levelUp ? 'LEVEL UP!' : 'QUEST CLEAR!',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: kGold,
                      letterSpacing: 1.2)),
              const SizedBox(height: 8),
              Text(
                  widget.levelUp
                      ? 'ยินดีด้วย! คุณขึ้นเลเวล ${widget.level} แล้ว'
                      : 'ภารกิจสำเร็จแล้ว!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 12),
              Text('+${widget.exp} EXP',
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w900, color: kBlue)),
              if (widget.levelUp)
                const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('พลังของคุณเพิ่มขึ้นอีกขั้น',
                        style: TextStyle(color: kMuted))),
              const SizedBox(height: 20),
              SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      style: FilledButton.styleFrom(
                          backgroundColor: kGold, foregroundColor: kBg),
                      child: const Text('ไปต่อ'))),
            ]),
          ),
        ),
      );
}
