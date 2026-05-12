import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'products_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController email =
    TextEditingController();

    TextEditingController password =
    TextEditingController();

    return Scaffold(

      body: Center(
        child: Container(

          width: 420,
          padding: const EdgeInsets.all(30),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.circular(20),
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
                controller: email,

                decoration: InputDecoration(
                  hintText: "البريد الإلكتروني",

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: password,
                obscureText: true,

                decoration: InputDecoration(
                  hintText: "كلمة المرور",

                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 30),
SizedBox(
  width: double.infinity,
  height: 55,

  child: ElevatedButton(

    style: ElevatedButton.styleFrom(
      backgroundColor:
      Colors.deepPurple,
    ),

    onPressed: () async {

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setBool(
          "isLoggedIn",
          true
      );

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ProductsPage(),
        ),
      );
    },

    child: const Text(
      "تسجيل الدخول",
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
  ),
),

const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  height: 55,

  child: OutlinedButton(

    style: OutlinedButton.styleFrom(
      side: const BorderSide(
        color: Colors.deepPurple,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(15),
      ),
    ),

    onPressed: () async {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      await prefs.setBool(
          "isLoggedIn",
          true
      );

      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ProductsPage(),
        ),
      );
    },

    child: const Text(
      "إنشاء حساب",
      style: TextStyle(
        fontSize: 18,
        color: Colors.deepPurple,
      ),
    ),
  ),
),
    
          ],
        ),
        ),
        ),
        );
  }}
