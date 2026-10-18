import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../theme/app_theme.dart';

class BossBattleScreen extends StatelessWidget {
  const BossBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);
    final boss = store.boss;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: SoloTheme.systemBoxDecoration(borderColor: SoloTheme.darkRed),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: SoloTheme.darkRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: SoloTheme.darkRed.withOpacity(0.5)),
                ),
                child: const Text(
                  'WARNING: GATE OPENED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: SoloTheme.darkRed,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.shield_outlined, size: 80, color: SoloTheme.darkRed),
              const SizedBox(height: 16),
              Text(
                boss.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: SoloTheme.textBright,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: boss.currentHp / boss.maxHp,
                  backgroundColor: const Color(0xFF1E293B),
                  color: SoloTheme.darkRed,
                  minHeight: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'HP: ${boss.currentHp} / ${boss.maxHp}',
                style: const TextStyle(fontSize: 13, color: SoloTheme.darkRed, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (boss.isDefeated) ...[
                const Text(
                  'DUNGEON CLEARED!',
                  style: TextStyle(color: SoloTheme.goldAccent, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: SoloTheme.goldAccent),
                  ),
                  onPressed: () => store.resetBoss(),
                  child: const Text('Enter New Dungeon', style: TextStyle(color: SoloTheme.goldAccent, fontWeight: FontWeight.bold)),
                )
              ] else ...[
                Text(
                  'Complete quests to attack the boss.\nAttack Power: ${30 + store.profile.strStat}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: SoloTheme.textMuted, fontSize: 12, height: 1.5),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}