import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // ضروري جداً لاستخدام kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_auth/firebase_auth.dart';

// استدعاء واجهات زملائك (تأكد من مطابقة المسارات)
import 'web_app/HomePageWeb.dart';
import 'mobile_app/HomePageMobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gift Store',
      debugShowCheckedModeBanner: false,
      // هنا الفحص الذكي
      home: kIsWeb
          ?  HomePageWeb()     // واجهة الويب لصاحب العمل
          :  HomePageMobile(),     // واجهة الموبايل للمشترين
    );
  }
}