# QuestLife RPG Upgrade (น้ำเงิน-ทอง)

## ไฟล์ที่ต้องแทนที่
คัดลอกไฟล์จากโฟลเดอร์ `lib/` ในชุดนี้ไปแทนไฟล์ที่มีชื่อเดียวกันในโปรเจกต์เดิม:
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

## ข้อมูลผู้พัฒนา
หน้าแรกแสดงชื่อ เดชาวัต บุตรงาม และรหัสผู้พัฒนา 016830641021-3

## คุณสมบัติ
- ธีม Dark RPG สีน้ำเงิน-ทอง
- เลเวล, Rank D-S, EXP และแถบ EXP แบบเคลื่อนไหว
- แอนิเมชัน Quest Clear / Level Up
- Streak รายวันและสถิติ Streak สูงสุด
- ตรารางวัลเพิ่มเติมและค่าสถานะ INT / STR / VIT
- บันทึกภารกิจ, EXP, โบนัส และ Streak ด้วย SharedPreferences ในเครื่อง

## ขั้นตอนทดสอบ
รันจากโฟลเดอร์ที่มี `pubspec.yaml`:
```bash
flutter pub get
dart format lib
flutter analyze
flutter test
flutter run
```

## สร้าง APK
```bash
flutter build apk --release
```
APK: `build/app/outputs/flutter-apk/app-release.apk`

หมายเหตุ: การนับ Streak จะเพิ่มเมื่อทำภารกิจอย่างน้อยหนึ่งรายการในวันใหม่ โดยต้องเป็นวันที่ต่อจากวันล่าสุดที่ทำภารกิจ หากข้ามวันจะเริ่มนับใหม่
