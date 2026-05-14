
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // تأكدي من وجود هذا السطر

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,

    // الحل هنا: تأكدي من تطابق هذه الأسماء تماماً
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate, // تأكدي من كتابة Cupertino بشكل صحيح
    ],
    supportedLocales: [
      Locale("ar", "AE"), // اللغة العربية
    ],
    locale: Locale("ar", "AE"), // ضبط الواجهة لليمين

    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xFF4A148C), // بنفسجي غامق جداً
              Color(0xFF7B1FA2), // بنفسجي متوسط
              Color(0xFF9C27B0), // بنفسجي زاهي
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("متجر الهدايا",
                      style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("نسعد بانضمامكِ إلينا..",
                      style: TextStyle(color: Colors.white70, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 40),
                        // صندوق المدخلات
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(123, 31, 162, 0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                textAlign: TextAlign.right, // محاذاة النص لليمين
                                decoration: const InputDecoration(
                                  hintText: "البريد الإلكتروني",
                                  prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF7B1FA2)),
                                  border: InputBorder.none,
                                ),
                                validator: (value) => value!.isEmpty ? "الرجاء إدخال البريد" : null,
                              ),
                              const Divider(height: 1, color: Colors.grey),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: "كلمة المرور",
                                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7B1FA2)),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) => value!.length < 6 ? "كلمة المرور قصيرة" : null,
                              ),
                            ],
                          ),
                        ),
                        // ... الكود السابق ...

                        const SizedBox(height: 50),

// 1. زر الدخول الأساسي
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("تمت عملية الدخول بنجاح");
                                // هنا سننتقل لصفحة البيانات الشخصية لاحقاً
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B1FA2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                            ),
                            child: const Text("تسجيل دخول",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 15),

                          // 2. زر إنشاء حساب جديد (الذي طلبتِه)
                        TextButton(
                          onPressed: () {
                            print("الانتقال لصفحة إنشاء حساب جديد");
                          },
                          child: const Text(
                            "ليس لديكِ حساب؟ تسجيل جديد",
                            style: TextStyle(
                                color: Color(0xFF7B1FA2),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ),

                          // زر جوجل
                          // ... باقي الكود ...
                        const SizedBox(height: 50),
                        // زر الدخول
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                print("تمت عملية الدخول بنجاح");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7B1FA2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                            ),
                            child: const Text("دخول",
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text("أو الدخول بواسطة", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 20),
                        // زر جوجل
                        InkWell(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF7B1FA2)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Google", style: TextStyle(color: Color(0xFF7B1FA2), fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Icon(Icons.g_mobiledata, size: 35, color: const Color(0xFF7B1FA2)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
}
