import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // تسجيل مستخدم جديد
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return res.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // تسجيل دخول
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return res.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // // تسجيل الدخول بواسطة جوجل بعد التعديل النهائي
  // Future<User?> signInWithGoogle() async {
  //   try {
  //     // 1. بدء عملية اختيار الحساب من جوجل
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     // إذا قام المستخدم بإغلاق النافذة ولم يختار حساباً
  //     if (googleUser == null) return null;
  //
  //     // 2. الحصول على بيانات المصادقة (التوكنز)
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     // 3. إنشاء بيانات الاعتماد لـ Firebase (استخدام ! لحل مشكلة النوع)
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken!,
  //       idToken: googleAuth.idToken!,
  //     );
  //
  //     // 4. تسجيل الدخول في Firebase والحصول على المستخدم
  //     UserCredential res = await _auth.signInWithCredential(credential);
  //
  //     return res.user;
  //   } catch (e) {
  //     // طباعة الخطأ في حال فشل الإعدادات أو الاتصال
  //     print("Google Sign-In Error: ${e.toString()}");
  //     return null;
  //   }
  // }
  Future signOut() async => await _auth.signOut();
}