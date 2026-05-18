import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../firebaseAuthService.dart';
import 'Details.dart';
import 'HomePageMobile.dart';
import 'TrakingOrders.dart';


class ProductsDisplayScreen extends StatefulWidget {
  const ProductsDisplayScreen({super.key});

  @override
  State<ProductsDisplayScreen> createState() => _ProductsDisplayScreenState();
}

class _ProductsDisplayScreenState extends State<ProductsDisplayScreen> {
  AuthService authService =AuthService();
  List<Map<String, dynamic>> cartItems = [];
  final User? currentUser = FirebaseAuth.instance.currentUser;
  String selectedCategory = "بوكسات هدايا جاهزه";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("قائمة الهدايا", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A1B9A),
        centerTitle: true,
        actions: [_buildCartBadge()],
      ),
      drawer: _buildDrawer(), // تم تحديثه لجلب بيانات المستخدم
      body: Column(
        children: [
          // شريط التصنيفات
          Container(
            height: 65,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryButton("بوكسات هدايا جاهزه"),
                categoryButton("توزيعات"),
                categoryButton("عطور"),
                categoryButton("بوكيهات ورد"),
              ],
            ),
          ),

          // عرض المنتجات من الفايربيس
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .where("category", isEqualTo: selectedCategory)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF6A1B9A)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("لا توجد منتجات في هذا القسم حالياً"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    return ProductCard(
                      doc: doc,
                      onAddToCart: (item) {
                        setState(() => cartItems.add(item));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم إضافة ${item['name']} للسلة"), duration: const Duration(seconds: 1)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String title) {
    bool isSelected = selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: isSelected ? 4 : 0,
          backgroundColor: isSelected ? const Color(0xFF6A1B9A) : Colors.white,
          side: BorderSide(color: isSelected ? const Color(0xFF6A1B9A) : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () => setState(() => selectedCategory = title),
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
      ),
    );
  }

  Widget _buildCartBadge() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen(cartItems: cartItems)));
          },
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
        if (cartItems.isNotEmpty)
          Positioned(
            right: 5, top: 5,
            child: CircleAvatar(
              radius: 8, backgroundColor: Colors.red,
              child: Text(cartItems.length.toString(), style: const TextStyle(fontSize: 10, color: Colors.white)),
            ),
          )
      ],
    );
  }

  // تحديث الدراور ليجلب اسم المستخدم من Firestore
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // استخدمنا StreamBuilder هنا لجلب اسم المستخدم الحقيقي
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("users").doc(currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                String userName = "مرحباً بكِ";
                if (snapshot.hasData && snapshot.data!.exists) {
                  userName = snapshot.data!.get("name") ?? "عميلتنا العزيزة";
                }

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFFAD1457)])),
                  currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 45, color: Color(0xFFAD1457))
                  ),
                  accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  accountEmail: Text(currentUser?.email ?? "لا يوجد بريد مسجل"),
                );
              }
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFF6A1B9A)),
            title: const Text("المنتجات"),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.track_changes, color: Color(0xFF6A1B9A)),
            title: const Text("تتبع الطلب"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderTrackingScreen()));
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("تسجيل الخروج"),
            onTap: () async {
              await authService.signOut();
              if (context.mounted) {
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
    (route) => false, // هذا السطر يمسح كاش الشاشات السابقة تماماً
    );}
            }
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final DocumentSnapshot doc;
  final Function(Map<String, dynamic>) onAddToCart;
  const ProductCard({super.key, required this.doc, required this.onAddToCart});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    var data = widget.doc.data() as Map<String, dynamic>;

    // فك تشفير الصورة من Base64 المخزن في فايربيس
    dynamic imageWidget;
    try {
      var imageBytes = base64Decode(data['image']);
      imageWidget = Image.memory(imageBytes, height: 200, width: double.infinity, fit: BoxFit.cover);
    } catch (e) {
      imageWidget = Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.image_not_supported));
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: imageWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(data['name'] ?? "منتج بدون اسم", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A))),
                Text(data['description'] ?? "", style: const TextStyle(color: Colors.grey), textAlign: TextAlign.right),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${data['price']} ريال", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFAD1457))),
                    _buildQuantityControl(),
                  ],
                ),
                const SizedBox(height: 15),
                _buildActionButtons(data),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Row(
      children: [
        IconButton(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add_circle, color: Color(0xFFAD1457))),
        Text("$quantity"),
        IconButton(onPressed: () { if (quantity > 1) setState(() => quantity--); }, icon: const Icon(Icons.remove_circle, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => widget.onAddToCart({...data, "quantity": quantity}),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text("إضافة للسلة", style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(cartItems: [{...data, "quantity": quantity}])));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAD1457), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text("شراء الآن", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}