import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../models/quest.dart';
import '../theme/app_theme.dart';

class QuestBoardScreen extends StatelessWidget {
  const QuestBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: SoloTheme.background,
        appBar: const TabBar(
          indicatorColor: SoloTheme.neonBlue,
          indicatorWeight: 3,
          labelColor: SoloTheme.neonBlue,
          unselectedLabelColor: SoloTheme.textMuted,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
          tabs: [
            Tab(text: 'DAILY QUESTS'),
            Tab(text: 'WEEKLY'),
            Tab(text: 'ALL SYSTEM'),
          ],
        ),
        body: TabBarView(
          children: [
            _buildQuestList(context, store.quests.where((q) => q.questType == QuestType.daily).toList()),
            _buildQuestList(context, store.quests.where((q) => q.questType == QuestType.weekly).toList()),
            _buildQuestList(context, store.quests),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: SoloTheme.neonBlue,
          shape: const BeveledRectangleBorder(),
          child: const Icon(Icons.add, color: Colors.black, size: 28),
          onPressed: () => _showAddQuestDialog(context),
        ),
      ),
    );
  }

  Widget _buildQuestList(BuildContext context, List<Quest> quests) {
    if (quests.isEmpty) {
      return const Center(
        child: Text(
          '[ NO ACTIVE QUESTS FOUND ]',
          style: TextStyle(color: SoloTheme.textMuted, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      );
    }
    final store = Provider.of<QuestStore>(context, listen: false);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final q = quests[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: SoloTheme.systemBoxDecoration(
            borderColor: q.isCompleted ? SoloTheme.textMuted : SoloTheme.neonBlue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: q.isCompleted ? SoloTheme.textMuted : SoloTheme.neonBlue,
                    child: Text(
                      q.questType == QuestType.daily ? 'DAILY QUEST' : 'SPECIAL QUEST',
                      style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ),
                  Text(
                    'STAT: [${q.statType}]',
                    style: const TextStyle(color: SoloTheme.goldAccent, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                q.title.toUpperCase(),
                style: TextStyle(
                  decoration: q.isCompleted ? TextDecoration.lineThrough : null,
                  color: q.isCompleted ? SoloTheme.textMuted : SoloTheme.textBright,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                q.description,
                style: const TextStyle(fontSize: 11, color: SoloTheme.textMuted),
              ),
              const Divider(color: SoloTheme.cardBg, height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REWARD: +${q.expReward} EXP  |  +${q.goldReward} GOLD',
                    style: const TextStyle(fontSize: 11, color: SoloTheme.neonCyan, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: q.isCompleted ? SoloTheme.textMuted : SoloTheme.neonBlue),
                      shape: const BeveledRectangleBorder(),
                    ),
                    onPressed: q.isCompleted ? null : () => store.completeQuest(q),
                    child: Text(
                      q.isCompleted ? 'CLEARED' : 'COMPLETE',
                      style: TextStyle(
                        color: q.isCompleted ? SoloTheme.textMuted : SoloTheme.neonBlue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddQuestDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    QuestType selectedType = QuestType.daily;
    String selectedStat = 'STR';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SoloTheme.cardBg,
        shape: Border.all(color: SoloTheme.neonBlue, width: 2),
        title: const Text(
          '[ NEW QUEST GENERATED ]',
          style: TextStyle(color: SoloTheme.neonBlue, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: SoloTheme.textBright),
              decoration: const InputDecoration(
                labelText: 'QUEST NAME',
                labelStyle: TextStyle(color: SoloTheme.textMuted),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: SoloTheme.neonBlue)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descController,
              style: const TextStyle(color: SoloTheme.textBright),
              decoration: const InputDecoration(
                labelText: 'DESCRIPTION',
                labelStyle: TextStyle(color: SoloTheme.textMuted),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: SoloTheme.neonBlue)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<QuestType>(
              value: selectedType,
              isExpanded: true,
              dropdownColor: SoloTheme.cardBg,
              style: const TextStyle(color: SoloTheme.textBright),
              items: const [
                DropdownMenuItem(value: QuestType.daily, child: Text('DAILY QUEST')),
                DropdownMenuItem(value: QuestType.weekly, child: Text('WEEKLY QUEST')),
                DropdownMenuItem(value: QuestType.normal, child: Text('NORMAL QUEST')),
              ],
              onChanged: (val) {
                if (val != null) selectedType = val;
              },
            ),
            DropdownButton<String>(
              value: selectedStat,
              isExpanded: true,
              dropdownColor: SoloTheme.cardBg,
              style: const TextStyle(color: SoloTheme.textBright),
              items: const [
                DropdownMenuItem(value: 'STR', child: Text('STAT REWARD: STR')),
                DropdownMenuItem(value: 'INT', child: Text('STAT REWARD: INT')),
                DropdownMenuItem(value: 'VIT', child: Text('STAT REWARD: VIT')),
              ],
              onChanged: (val) {
                if (val != null) selectedStat = val;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: SoloTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SoloTheme.neonBlue,
              shape: const BeveledRectangleBorder(),
            ),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newQ = Quest(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descController.text,
                  expReward: 60,
                  goldReward: 25,
                  statType: selectedStat,
                  questType: selectedType,
                );
                Provider.of<QuestStore>(context, listen: false).addQuest(newQ);
                Navigator.pop(ctx);
              }
            },
            child: const Text('ACCEPT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}