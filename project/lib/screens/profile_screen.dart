import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);
    final p = store.profile;
    final jobs = ['Shadow Monarch', 'Necromancer', 'Assassin', 'Knight', 'Mage'];

    final String titleText = p.currentTitle.isEmpty ? 'Wolf Slayer' : p.currentTitle;
    final String playerNameText = p.playerName.isEmpty ? 'Hunter' : p.playerName;
    final String jobText = p.jobClass.isEmpty ? 'Shadow Monarch' : p.jobClass;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player Status Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: SoloTheme.systemBoxDecoration(borderColor: SoloTheme.neonBlue.withOpacity(0.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PLAYER STATUS', style: TextStyle(color: SoloTheme.neonBlue, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: SoloTheme.goldAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: SoloTheme.goldAccent.withOpacity(0.5)),
                      ),
                      child: Text('TITLE: $titleText', style: const TextStyle(color: SoloTheme.goldAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(playerNameText, style: const TextStyle(fontSize: 20, color: SoloTheme.textBright, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.edit, color: SoloTheme.neonBlue, size: 18),
                      onPressed: () => _showEditNameDialog(context, store, p.playerName),
                    ),
                  ],
                ),
                const Divider(color: Color(0xFF1E293B), height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('JOB: $jobText', style: const TextStyle(fontSize: 13, color: SoloTheme.neonCyan)),
                    Text('RANK: ${p.rank}', style: const TextStyle(fontSize: 13, color: SoloTheme.goldAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Job Class Selection
          const Text('JOB CLASS', style: TextStyle(fontSize: 12, color: SoloTheme.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: SoloTheme.systemBoxDecoration(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: jobs.contains(p.jobClass) ? p.jobClass : jobs.first,
                isExpanded: true,
                dropdownColor: SoloTheme.cardBg,
                style: const TextStyle(color: SoloTheme.textBright),
                items: jobs.map((job) => DropdownMenuItem(value: job, child: Text(job))).toList(),
                onChanged: (val) {
                  if (val != null) store.changeJobClass(val);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // System Stats
          const Text('STATS', style: TextStyle(fontSize: 12, color: SoloTheme.textMuted, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 8),
          _buildStatRow('STR (Strength)', p.strStat, SoloTheme.darkRed),
          const SizedBox(height: 8),
          _buildStatRow('INT (Intelligence)', p.intStat, SoloTheme.neonBlue),
          const SizedBox(height: 8),
          _buildStatRow('VIT (Vitality)', p.vitStat, SoloTheme.goldAccent),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, QuestStore store, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SoloTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: SoloTheme.neonBlue, width: 1),
        ),
        title: const Text('Change Player Name', style: TextStyle(color: SoloTheme.textBright, fontSize: 16)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: SoloTheme.textBright),
          decoration: const InputDecoration(
            labelText: 'Player Name',
            labelStyle: TextStyle(color: SoloTheme.textMuted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: SoloTheme.neonBlue)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: SoloTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: SoloTheme.neonBlue),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                store.updatePlayerName(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: SoloTheme.systemBoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: SoloTheme.textBright, fontSize: 13)),
          Text('$val', style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}