import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/quest_store.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuestStore(),
      child: const QuestLifeApp(),
    ),
  );
}

class QuestLifeApp extends StatelessWidget {
  const QuestLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestLife System RPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: SoloTheme.background,
        primaryColor: SoloTheme.neonBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: SoloTheme.background,
          foregroundColor: SoloTheme.neonBlue,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}