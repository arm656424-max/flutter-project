import 'package:flutter/material.dart';
import 'data/quest_store.dart';
import 'screens/home_screen.dart';
import 'screens/quest_board_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/stats_screen.dart';

const kBg = Color(0xFF080E1C);
const kPanel = Color(0xFF121D32);
const kPanel2 = Color(0xFF1B2A45);
const kGold = Color(0xFFFFC857);
const kBlue = Color(0xFF55B8FF);
const kGreen = Color(0xFF66D9A8);
const kMuted = Color(0xFF9AAAC4);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = QuestStore();
  await store.load();
  runApp(QuestLifeApp(store: store));
}

class QuestLifeApp extends StatelessWidget {
  const QuestLifeApp({super.key, required this.store});
  final QuestStore store;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'QuestLife',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBg,
      colorScheme: const ColorScheme.dark(primary: kBlue, secondary: kGold, surface: kPanel),
      appBarTheme: const AppBarTheme(backgroundColor: kBg, foregroundColor: Colors.white),
      cardTheme: CardThemeData(color: kPanel, elevation: 0, margin: const EdgeInsets.only(bottom: 10)),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kPanel,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    ),
    home: MainShell(store: store),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.store});
  final QuestStore store;
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(store: widget.store, onNavigate: (i) => setState(() => index = i)),
      QuestBoardScreen(store: widget.store),
      ProfileScreen(store: widget.store),
      AchievementsScreen(store: widget.store),
      StatsScreen(store: widget.store),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        backgroundColor: kPanel,
        indicatorColor: kBlue.withOpacity(.16),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'หน้าหลัก'),
          NavigationDestination(icon: Icon(Icons.assignment_rounded), label: 'ภารกิจ'),
          NavigationDestination(icon: Icon(Icons.shield_moon_rounded), label: 'ตัวละคร'),
          NavigationDestination(icon: Icon(Icons.workspace_premium_rounded), label: 'รางวัล'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'สถิติ'),
        ],
      ),
    );
  }
}
