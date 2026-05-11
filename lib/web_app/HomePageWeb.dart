import 'package:flutter/material.dart';

import 'login_page.dart';

class HomePageWeb extends StatelessWidget {

  const HomePageWeb({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xfff7f5fc),

      body: Row(
        children: [

          Expanded(
            flex: 2,

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
              ),

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Icon(
                    Icons.card_giftcard,
                    size: 90,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "متجر الهدايا",

                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(

                    "نظام لإدارة متجر الهدايا يساعد صاحب العمل على إدارة المنتجات والطلبات بطريقة سهلة واحترافية.",

                    style: TextStyle(
                      fontSize: 20,
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                      Colors.deepPurple,

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 22,
                      ),
                    ),

                    onPressed: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoginPage(),
                        ),
                      );
                    },

                    child: const Text(
                      "ابدأ الآن",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          Expanded(

            child: Container(

              color: Colors.deepPurple,

              child: const Center(

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.redeem,
                      size: 180,
                      color: Colors.white,
                    ),

                    SizedBox(height: 30),

                    Text(
                      "إدارة احترافية للهدايا",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}