import 'package:cloud_firestore/cloud_firestore.dart';
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

  // for mobile
  // 1. دالة إنشاء حساب جديد (بدون اسم المستخدم)
  Future<User?> signUpForMobile(String email, String password) async {
    try {
      // إنشاء الحساب في قسم الـ Authentication
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = res.user;

      // إذا نجحت العملية، نفتح له وثيقة في الـ Firestore بالـ UID ونخزن الإيميل فقط
      if (user != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "name": "", // نتركه فارغاً ليتم تعبئته لاحقاً من صفحة البيانات الشخصية
          "createdAt": DateTime.now(),
        });
      }
      return user;
    } catch (e) {
      print("خطأ في إنشاء الحساب: ${e.toString()}");
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

  // تسجيل الدخول بواسطة جوجل بعد التعديل النهائي وحل أخطاء الإصدار المحدث
  Future<User?> signInWithGoogle() async {

    try {

      final GoogleSignIn googleSignIn =
      GoogleSignIn();

      final GoogleSignInAccount? googleUser =
      await googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final AuthCredential credential =
      GoogleAuthProvider.credential(

        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,

      );

      UserCredential res =
      await _auth.signInWithCredential(credential);

      User? user = res.user;

      // حفظ بيانات المستخدم داخل Firestore
      if (user != null) {

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({

          "uid": user.uid,
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "image": user.photoURL ?? "",
          "createdAt": DateTime.now(),

        }, SetOptions(merge: true));
      }

      return user;

    } catch (e) {

      print("Google Sign-In Error: $e");

      return null;
    }
  }

  Future signOut() async => await _auth.signOut();

  // 2. دالة حفظ وتحديث البيانات الشخصية (مع اسم المستخدم)
  Future<void> uploadProfileData(String name, String phone, String address) async {
    // جلب الـ UID للمستخدم الحالي النشط
    String? userId = _auth.currentUser?.uid;

    if (userId != null) {
      // نذهب لوثيقة المستخدم ونقوم بتحديث الحقول أو إضافتها إن لم تكن موجودة
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,         // هنا يتم حفظ الاسم الذي أدخله المستخدم في صفحة البيانات
        'phone': phone,       // حفظ الهاتف
        'address': address,   // حفظ العنوان
        'lastUpdate': DateTime.now(),
      }, SetOptions(merge: true)); // خيار merge مهم جداً هنا لأنه سيحافظ على الإيميل القديم ويضيف عليه الاسم والبيانات الجديدة
    }
  }
}