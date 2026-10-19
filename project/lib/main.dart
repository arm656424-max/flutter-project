import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'data/quest_store.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  // จำเป็นสำหรับการตั้งค่า SystemChrome ก่อนรัน runApp
  WidgetsFlutterBinding.ensureInitialized();

  // บังคับหน้าจอให้เป็นแนวตั้งเท่านั้น (Portrait Mode Only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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