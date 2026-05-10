import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';
import 'edit_product_page.dart';
import 'orders_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() =>
      _ProductsPageState();
}

class _ProductsPageState
    extends State<ProductsPage> {

  String selectedCategory =
      "بوكسات هدايا جاهزة";

  List products = [

    {
      "name": "بوكس شوكولاتة",
      "price": "120",
      "category": "بوكسات هدايا جاهزة",
      "description":
      "بوكس فاخر يحتوي شوكولاتة وورد"
    },

    {
      "name": "بوكس سبا",
      "price": "180",
      "category": "بوكسات هدايا جاهزة",
      "description":
      "مجموعة سبا متكاملة"
    },

    {
      "name": "كوب باسم",
      "price": "45",
      "category": "هدايا مخصصة",
      "description":
      "كوب مطبوع باسم حسب الطلب"
    },

    {
      "name": "شمعة",
      "price": "25",
      "category": "قطع هدايا",
      "description":
      "شمعة عطرية جميلة"
    },
  ];

  @override
  Widget build(BuildContext context) {

    List filteredProducts =
    products.where((product) {

      return product["category"]
      == selectedCategory;

    }).toList();

    return Scaffold(

      body: Row(
        children: [

          /// SIDE MENU
          Container(

            width: 240,
            color: Colors.deepPurple,

            child: Column(
              children: [

                const SizedBox(height: 40),

                const Icon(
                  Icons.card_giftcard,
                  size: 80,
                  color: Colors.white,
                ),

                const SizedBox(height: 10),

                const Text(
                  "متجر الهدايا",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                menuButton(
                  "المنتجات",
                  Icons.shopping_bag,
                ),

                menuButton(
                  "تعديل البيانات",
                  Icons.edit,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const EditProductPage(),
                      ),
                    );
                  },
                ),

                menuButton(
                  "الطلبات",
                  Icons.receipt_long,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const OrdersPage(),
                      ),
                    );
                  },
                ),

                const Spacer(),

                menuButton(
                  "تسجيل الخروج",
                  Icons.logout,
                      () async {

                    SharedPreferences prefs =
                    await SharedPreferences
                        .getInstance();

                    await prefs.clear();

                    if (!context.mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const LoginPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.all(25),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  const Text(
                    "المنتجات",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [

                      categoryButton(
                          "بوكسات هدايا جاهزة"),

                      categoryButton(
                          "هدايا مخصصة"),

                      categoryButton(
                          "قطع هدايا"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: GridView.builder(

                      itemCount:
                      filteredProducts.length,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.8,
                      ),

                      itemBuilder:
                          (context, index) {

                        var product =
                        filteredProducts[index];

                        return Container(

                          padding:
                          const EdgeInsets.all(20),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(20),

                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors
                                    .grey
                                    .shade200,
                              )
                            ],
                          ),

                          child: Column(
                            children: [

                              const Icon(
                                Icons.card_giftcard,
                                size: 80,
                                color:
                                Colors.deepPurple,
                              ),

                              const SizedBox(
                                  height: 20),

                              Text(
                                product["name"],

                                style:
                                const TextStyle(
                                  fontSize: 22,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                product["description"],
                                textAlign:
                                TextAlign.center,
                              ),

                              const Spacer(),

                              Text(
                                "${product["price"]} ريال",

                                style:
                                const TextStyle(
                                  color: Colors
                                      .deepPurple,

                                  fontSize: 22,

                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget categoryButton(String title) {

    return Padding(
      padding:
      const EdgeInsets.only(right: 10),

      child: ElevatedButton(

        style: ElevatedButton.styleFrom(

          backgroundColor:
          selectedCategory == title
              ? Colors.deepPurple
              : Colors.grey.shade300,
        ),

        onPressed: () {

          setState(() {
            selectedCategory = title;
          });
        },

        child: Text(title),
      ),
    );
  }

  Widget menuButton(
      String title,
      IconData icon,
      [VoidCallback? onTap]
      ) {

    return ListTile(

      leading: Icon(
        icon,
        color: Colors.white,
      ),

      title: Text(
        title,
        style:
        const TextStyle(color: Colors.white),
      ),

      onTap: onTap,
    );
  }
}