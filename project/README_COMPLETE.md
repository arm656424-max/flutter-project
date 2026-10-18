# QuestLife — Complete RPG Upgrade

ธีม Dark RPG น้ำเงิน–ทอง พร้อมระบบภารกิจ, EXP/Level, Rank, Streak, achievements, daily bonus, ค่าสถานะ, แอนิเมชัน และข้อมูลผู้พัฒนา

## สิ่งที่ควรรู้ก่อนแทนที่
1. สำรองโปรเจกต์เดิมก่อน
2. ชุดนี้เป็น source patch สำหรับวางในโปรเจกต์ Flutter เดิม ไม่ใช่ APK ที่คอมไพล์แล้ว
3. โค้ดใช้ SharedPreferences สำหรับบันทึกข้อมูลในเครื่อง ไม่ต้อง Login
4. เมื่ออัปเดตแอป ข้อมูลเดิมที่ใช้ key `questlife_*_v1` จะถูกพยายามอ่านแบบปลอดภัย หากรูปแบบข้อมูลเสียหายจะใช้ภารกิจเริ่มต้นแทน

## ไฟล์ที่รวม
- `lib/main.dart`
- `lib/data/quest_store.dart` — อ่านค่าที่อาจเป็น null/ชนิดผิดอย่างปลอดภัย และกัน load ซ้ำ
- `lib/models/quest.dart` — แปลง JSON แบบ defensive
- `lib/models/user_profile.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/quest_board_screen.dart`
- `lib/screens/quest_detail_screen.dart`
- `lib/screens/profile_screen.dart`
- `lib/screens/achievements_screen.dart`
- `lib/screens/stats_screen.dart`
- `test/quest_model_test.dart`

## วิธีติดตั้งใน Codespaces
จากโฟลเดอร์ที่มี `pubspec.yaml`:

```bash
# สำรองก่อน (แนะนำ)
cp -r lib lib.backup

# หลังคัดลอกไฟล์จาก ZIP ไปทับในโปรเจกต์แล้ว
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d chrome
```

ถ้าหน้าเว็บยังจำค่าเก่าที่เสียไว้ ให้เปิด DevTools > Application > Local Storage แล้วลบเฉพาะรายการ SharedPreferences ของเว็บแอป QuestLife หรือทดสอบในหน้าต่าง InPrivate ก่อน การล้าง Local Storage จะลบข้อมูลที่บันทึกในเว็บนั้นด้วย

## สร้าง Android APK
```bash
flutter build apk --release
```
ผลลัพธ์: `build/app/outputs/flutter-apk/app-release.apk`

## ข้อจำกัดการตรวจสอบ
ชุดนี้จัดเตรียมและตรวจโครงสร้างไฟล์แล้ว แต่สภาพแวดล้อมนี้ไม่มี Flutter SDK จึงไม่ได้รัน `flutter analyze`, `flutter test` หรือ build APK จริงบนเครื่องของคุณ หากมี error ให้ส่งผลลัพธ์ Terminal เต็ม ๆ มาเพื่อแก้ตรงบรรทัด
