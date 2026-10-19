import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../theme/app_theme.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  final TextEditingController _importController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);
    final p = store.profile;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Developer Info Card (2 Developers)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: SoloTheme.systemBoxDecoration(
              borderColor: SoloTheme.neonBlue.withOpacity(0.3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[ DEVELOPER INFORMATION ]',
                  style: TextStyle(
                    fontSize: 12,
                    color: SoloTheme.neonBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Developer 1
                Text(
                  'DEVELOPER 1: ${p.developer1Name}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: SoloTheme.textBright,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'STUDENT ID: ${p.studentId1}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SoloTheme.textMuted,
                  ),
                ),

                const Divider(color: Color(0xFF1E293B), height: 20),

                // Developer 2
                Text(
                  'DEVELOPER 2: ${p.developer2Name}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: SoloTheme.textBright,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'STUDENT ID: ${p.studentId2}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: SoloTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quest Recovery Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: SoloTheme.systemBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[ QUEST MANAGEMENT ]',
                  style: TextStyle(
                    fontSize: 12,
                    color: SoloTheme.neonCyan,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SoloTheme.neonCyan),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  icon: const Icon(Icons.refresh, color: SoloTheme.neonCyan, size: 18),
                  label: const Text(
                    'RELOAD DEFAULT QUESTS',
                    style: TextStyle(
                      color: SoloTheme.neonCyan,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  onPressed: () {
                    store.resetToDefaultQuests();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('DEFAULT QUESTS RESTORED')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Export System Data Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: SoloTheme.systemBoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[ EXPORT SYSTEM DATA ]',
                  style: TextStyle(
                    fontSize: 12,
                    color: SoloTheme.neonBlue,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SoloTheme.neonBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  icon: const Icon(Icons.copy, color: SoloTheme.neonBlue, size: 18),
                  label: const Text(
                    'COPY JSON TO CLIPBOARD',
                    style: TextStyle(
                      color: SoloTheme.neonBlue,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  onPressed: () {
                    final jsonStr = store.exportToJson();
                    Clipboard.setData(ClipboardData(text: jsonStr));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('SYSTEM DATA COPIED')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Restore System Data Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: SoloTheme.systemBoxDecoration(
              borderColor: SoloTheme.goldAccent.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '[ RESTORE SYSTEM DATA ]',
                  style: TextStyle(
                    fontSize: 12,
                    color: SoloTheme.goldAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _importController,
                  maxLines: 4,
                  style: const TextStyle(color: SoloTheme.textBright, fontSize: 12),
                  decoration: const InputDecoration(
                    hintText: 'PASTE JSON SYSTEM DATA HERE...',
                    hintStyle: TextStyle(color: SoloTheme.textMuted),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: SoloTheme.goldAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SoloTheme.goldAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  icon: const Icon(Icons.download, color: Colors.black, size: 18),
                  label: const Text(
                    'RESTORE DATA',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  onPressed: () {
                    final success = store.importFromJson(_importController.text.trim());
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SYSTEM RESTORE COMPLETED')),
                      );
                      _importController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('INVALID SYSTEM JSON FORMAT')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}