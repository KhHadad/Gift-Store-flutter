import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebaseAuthService.dart';
import 'ProfileScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // رسائل الأخطاء
  void _showErrorSnackBar(String errorCode) {

    String message =
        "حدث خطأ غير متوقع، يرجى المحاولة لاحقاً";

    switch (errorCode) {

      case 'invalid-email':
        message = "صيغة البريد الإلكتروني غير صحيحة";
        break;

      case 'user-not-found':
        message = "لا يوجد حساب بهذا البريد الإلكتروني";
        break;

      case 'wrong-password':
        message = "كلمة المرور غير صحيحة";
        break;

      case 'email-already-in-use':
        message = "هذا البريد مستخدم مسبقاً";
        break;

      case 'weak-password':
        message = "كلمة المرور ضعيفة جداً";
        break;

      case 'user-disabled':
        message = "تم تعطيل الحساب";
        break;

      case 'channel-error':
        message = "الرجاء تعبئة جميع الحقول";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [

              Color(0xFF4A148C),
              Color(0xFF7B1FA2),
              Color(0xFF9C27B0),

            ],
          ),
        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

            const SizedBox(height: 60),

            const Padding(

              padding: EdgeInsets.symmetric(horizontal: 30),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[

                  Text(
                    "متجر الهدايا",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "نسعد بانضمامكِ إلينا..",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 25),

            Expanded(

              child: Container(

                decoration: const BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),

                child: SingleChildScrollView(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 40,
                  ),

                  child: Column(

                    children: <Widget>[

                      // الحقول
                      Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(

                          color: Colors.white,

                          borderRadius: BorderRadius.circular(20),

                          boxShadow: const [

                            BoxShadow(
                              color: Color.fromRGBO(
                                  123, 31, 162, 0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),

                          ],
                        ),

                        child: Column(

                          children: <Widget>[

                            // البريد
                            TextFormField(

                              controller: _emailController,

                              textAlign: TextAlign.right,

                              keyboardType:
                              TextInputType.emailAddress,

                              decoration: const InputDecoration(

                                hintText: "البريد الإلكتروني",

                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF7B1FA2),
                                ),

                                border: InputBorder.none,
                              ),
                            ),

                            const Divider(
                              height: 1,
                              color: Colors.grey,
                            ),

                            // كلمة المرور
                            TextFormField(

                              controller: _passwordController,

                              obscureText:
                              !_isPasswordVisible,

                              textAlign: TextAlign.right,

                              decoration: InputDecoration(

                                hintText: "كلمة المرور",

                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF7B1FA2),
                                ),

                                suffixIcon: IconButton(

                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),

                                  onPressed: () {

                                    setState(() {

                                      _isPasswordVisible =
                                      !_isPasswordVisible;

                                    });
                                  },
                                ),

                                border: InputBorder.none,
                              ),
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // التحميل
                      if (_isLoading)

                        const CircularProgressIndicator(
                          color: Color(0xFF7B1FA2),
                        )

                      else ...[

                        // تسجيل الدخول
                        SizedBox(

                          width: double.infinity,
                          height: 55,

                          child: ElevatedButton(

                            onPressed: () async {

                              setState(() {
                                _isLoading = true;
                              });

                              try {

                                User? user =
                                await _authService.signIn(

                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),

                                );

                                if (user != null) {

                                  Navigator.pushReplacement(

                                    context,

                                    MaterialPageRoute(

                                      builder: (context) =>
                                      const ProfileScreen(),

                                    ),
                                  );
                                } else {

                                  _showErrorSnackBar(
                                      'wrong-password');

                                }

                              } on FirebaseAuthException catch (e) {

                                _showErrorSnackBar(e.code);

                              } finally {

                                setState(() {
                                  _isLoading = false;
                                });

                              }
                            },

                            style: ElevatedButton.styleFrom(

                              backgroundColor:
                              const Color(0xFF7B1FA2),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(

                              "تسجيل الدخول",

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // إنشاء حساب
                        SizedBox(

                          width: double.infinity,
                          height: 55,

                          child: OutlinedButton(

                            onPressed: () async {

                              setState(() {
                                _isLoading = true;
                              });

                              try {

                                User? user =
                                await _authService
                                    .signUpForMobile(

                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),

                                );

                                if (user != null) {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    const SnackBar(

                                      backgroundColor:
                                      Colors.green,

                                      content: Text(
                                        "تم إنشاء الحساب بنجاح",
                                        textAlign:
                                        TextAlign.right,
                                      ),
                                    ),
                                  );

                                  Navigator.pushReplacement(

                                    context,

                                    MaterialPageRoute(

                                      builder: (context) =>
                                      const ProfileScreen(),

                                    ),
                                  );
                                }

                              } on FirebaseAuthException catch (e) {

                                _showErrorSnackBar(e.code);

                              } finally {

                                setState(() {
                                  _isLoading = false;
                                });

                              }
                            },

                            style: OutlinedButton.styleFrom(

                              side: const BorderSide(
                                color: Color(0xFF7B1FA2),
                                width: 1.5,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(

                              "إنشاء حساب جديد",

                              style: TextStyle(
                                color: Color(0xFF7B1FA2),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      ],

                      const SizedBox(height: 35),

                      const Text(
                        "أو الدخول بواسطة",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      // تسجيل الدخول بجوجل
                      InkWell(

                        onTap: () async {

                          setState(() {
                            _isLoading = true;
                          });

                          try {

                            User? user =
                            await _authService
                                .signInWithGoogle();

                            if (user != null) {

                              Navigator.pushReplacement(

                                context,

                                MaterialPageRoute(

                                  builder: (context) =>
                                  const ProfileScreen(),

                                ),
                              );

                            } else {

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(

                                const SnackBar(

                                  content: Text(
                                    "تم إلغاء تسجيل الدخول",
                                    textAlign:
                                    TextAlign.right,
                                  ),
                                ),
                              );
                            }

                          } catch (e) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(

                              SnackBar(
                                content: Text(
                                  e.toString(),
                                ),
                              ),
                            );

                          } finally {

                            setState(() {
                              _isLoading = false;
                            });

                          }
                        },

                        borderRadius:
                        BorderRadius.circular(30),

                        child: Container(

                          height: 55,

                          decoration: BoxDecoration(

                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),

                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          child: Row(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              const Text(

                                "Google",

                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Icon(
                                Icons.g_mobiledata,
                                size: 40,
                                color: Colors.red.shade700,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}