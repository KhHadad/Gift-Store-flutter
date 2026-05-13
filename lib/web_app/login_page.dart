import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../firebaseAuthService.dart';
import 'products_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // جلب البيانات المحفوظة عند فتح الصفحة
  }

  // دالة لجلب البيانات من SharedPreferences ووضعها في الحقول
  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString("savedEmail") ?? "";
      passwordController.text = prefs.getString("savedPassword") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.card_giftcard,
                size: 90,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),
              const Text(
                "متجر الهدايا",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "البريد الإلكتروني",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "كلمة المرور",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // زر تسجيل الدخول المعدل
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    // 1. تسجيل الدخول عبر فيربيس
                    var user = await authService.signIn(emailController.text, passwordController.text);

                    if (user != null) {
                      // 2. حفظ البيانات في SharedPreferences
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("isLoggedIn", true);
                      await prefs.setString("savedEmail", emailController.text);
                      await prefs.setString("savedPassword", passwordController.text);

                      if (!context.mounted) return;

                      // 3. الانتقال للصفحة التالية
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductsPage()),
                      );
                    } else {
                      // يمكنك إضافة تنبيه هنا في حال فشل الدخول
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("خطأ في البيانات أو الحساب غير موجود")),
                      );
                    }
                  },
                  child: const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // زر إنشاء حساب
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    var user = await authService.signUp(emailController.text, passwordController.text);

                    if (user != null) {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("isLoggedIn", true);
                      // نحفظ البيانات أيضاً عند إنشاء الحساب لأول مرة
                      await prefs.setString("savedEmail", emailController.text);
                      await prefs.setString("savedPassword", passwordController.text);

                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductsPage()),
                      );
                    }
                  },
                  child: const Text(
                    "إنشاء حساب",
                    style: TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}