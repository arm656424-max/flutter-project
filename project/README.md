# QuestLife

## วางไฟล์
คัดลอก `lib/` ทั้งโฟลเดอร์และ `pubspec.yaml` ไปไว้ที่รากโปรเจกต์ Flutter เดิม โดยคงโครงสร้าง:
- `lib/main.dart`
- `lib/data/quest_store.dart`
- `lib/models/quest.dart`
- `lib/models/user_profile.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/quest_board_screen.dart`
- `lib/screens/quest_detail_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/achievements_screen.dart`
- `lib/screens/stats_screen.dart`

## คำสั่ง
```bash
flutter pub get
dart format lib
flutter analyze
flutter test
flutter build apk --release
```

APK อยู่ที่ `build/app/outputs/flutter-apk/app-release.apk`.

แอปใช้ SharedPreferences เก็บข้อมูลในเครื่อง ไม่ต้อง login หรือใช้ API ภายนอก
