import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/quest_store.dart';
import '../theme/app_theme.dart';
import 'quest_board_screen.dart';
import 'boss_battle_screen.dart';
import 'shop_screen.dart';
import 'profile_screen.dart';
import 'backup_restore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    QuestBoardScreen(),
    BossBattleScreen(),
    ShopScreen(),
    ProfileScreen(),
    BackupRestoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuestStore>(context);
    final p = store.profile;

    return Scaffold(
      backgroundColor: SoloTheme.background,
      appBar: AppBar(
        backgroundColor: SoloTheme.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: SoloTheme.goldAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: SoloTheme.goldAccent.withOpacity(0.4)),
              ),
              child: Text(
                'RANK ${p.rank}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: SoloTheme.goldAccent),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              p.playerName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: SoloTheme.textBright),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: SoloTheme.systemBoxDecoration(),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: SoloTheme.goldAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${p.gold}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: SoloTheme.goldAccent, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: SoloTheme.systemBoxDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('LEVEL ${p.level}', style: const TextStyle(fontWeight: FontWeight.bold, color: SoloTheme.textBright, fontSize: 13)),
                    Text('EXP ${p.exp} / ${p.maxExp}', style: const TextStyle(fontSize: 11, color: SoloTheme.neonBlue)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: p.exp / p.maxExp,
                    backgroundColor: const Color(0xFF1E293B),
                    color: SoloTheme.neonBlue,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: SoloTheme.cardBg,
        selectedItemColor: SoloTheme.neonBlue,
        unselectedItemColor: SoloTheme.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Quests'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Dungeon'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'System'),
        ],
      ),
    );
  }
}