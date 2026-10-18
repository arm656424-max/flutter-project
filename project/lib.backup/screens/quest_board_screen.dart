import 'package:flutter/material.dart';
import '../data/quest_store.dart';
import '../models/quest.dart';
import '../main.dart';
import 'quest_detail_screen.dart';

class QuestBoardScreen extends StatefulWidget {
  const QuestBoardScreen({super.key, required this.store});
  final QuestStore store;
  @override
  State<QuestBoardScreen> createState() => _QuestBoardScreenState();
}

class _QuestBoardScreenState extends State<QuestBoardScreen> {
  String filter = 'ทั้งหมด';

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.store,
    builder: (context, _) {
      final list = widget.store.quests.where((q) {
        if (filter == 'กำลังทำ') return !q.completed;
        if (filter == 'สำเร็จแล้ว') return q.completed;
        return true;
      }).toList();
      return Scaffold(
        backgroundColor: kBg,
        appBar: AppBar(title: const Text('กระดานภารกิจ'), actions: [
          IconButton(onPressed: () => _editQuest(context), icon: const Icon(Icons.add_circle, color: kGold), tooltip: 'เพิ่มภารกิจ'),
        ]),
        body: Column(children: [
          const Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 12), child: Align(alignment: Alignment.centerLeft, child: Text('ทำภารกิจเพื่อสะสม EXP และเพิ่ม Streak', style: TextStyle(color: kMuted)))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Wrap(spacing: 8, children: ['ทั้งหมด', 'กำลังทำ', 'สำเร็จแล้ว'].map((f) => ChoiceChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f))).toList())),
          const SizedBox(height: 8),
          Expanded(child: list.isEmpty
            ? const Center(child: Text('ไม่มีภารกิจในหมวดนี้', style: TextStyle(color: kMuted)))
            : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final q = list[i];
                return Card(
                  child: ListTile(
                    leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: (q.completed ? kGreen : kBlue).withOpacity(.12), borderRadius: BorderRadius.circular(12)), child: Icon(q.completed ? Icons.check_circle : Icons.assignment, color: q.completed ? kGreen : kBlue)),
                    title: Text(q.title),
                    subtitle: Text('${categoryLabel(q.category)} • ${difficultyLabel(q.difficulty)} • ${q.exp} EXP', style: const TextStyle(color: kMuted)),
                    trailing: const Icon(Icons.chevron_right, color: kGold),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestDetailScreen(store: widget.store, questId: q.id))),
                  ),
                );
              },
            )),
        ]),
      );
    },
  );

  Future<void> _editQuest(BuildContext context) async {
    final title = TextEditingController();
    final desc = TextEditingController();
    QuestCategory category = QuestCategory.study;
    QuestDifficulty difficulty = QuestDifficulty.easy;
    await showModalBottomSheet<void>(
      context: context, isScrollControlled: true, backgroundColor: kBg,
      builder: (sheetContext) => StatefulBuilder(builder: (context, setSheetState) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('สร้างภารกิจใหม่', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: kGold)),
          const SizedBox(height: 16),
          TextField(controller: title, maxLength: 60, decoration: const InputDecoration(labelText: 'ชื่อภารกิจ')),
          const SizedBox(height: 8),
          TextField(controller: desc, maxLines: 2, decoration: const InputDecoration(labelText: 'รายละเอียด')),
          const SizedBox(height: 12),
          DropdownButtonFormField<QuestCategory>(
            value: category, decoration: const InputDecoration(labelText: 'หมวดหมู่'),
            items: QuestCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(categoryLabel(c)))).toList(),
            onChanged: (v) { if (v != null) setSheetState(() => category = v); },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<QuestDifficulty>(
            value: difficulty, decoration: const InputDecoration(labelText: 'ความยาก'),
            items: QuestDifficulty.values.map((d) => DropdownMenuItem(value: d, child: Text('${difficultyLabel(d)} (${difficultyExp(d)} EXP)'))).toList(),
            onChanged: (v) { if (v != null) setSheetState(() => difficulty = v); },
          ),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kGold, foregroundColor: kBg),
            onPressed: () async {
              if (title.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('กรุณาใส่ชื่อภารกิจ')));
                return;
              }
              await widget.store.addQuest(Quest(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title.text.trim(), description: desc.text.trim(), category: category, difficulty: difficulty));
              if (sheetContext.mounted) Navigator.pop(sheetContext);
            },
            child: const Text('บันทึกภารกิจ'),
          )),
        ])),
      )),
    );
    title.dispose();
    desc.dispose();
  }
}
