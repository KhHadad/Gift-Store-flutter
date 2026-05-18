import 'dart:convert'; // ضروري جداً لفك تشفير الصور Base64
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// استيراد الملفات الخاصة بمشروعك (تأكد من مطابقة المسارات في مشروعك)
import '../DatabaseMethods.dart';
import '../firebaseAuthService.dart';
import 'login_page.dart';
import 'edit_product_page.dart';
import 'orders_page.dart';
import 'add_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = "بوكسات هدايا جاهزه";
  final DatabaseMethods _databaseMethods = DatabaseMethods();
  AuthService authService=AuthService();

  // تعريف الـ Stream كمتغير متأخر (late) ليتم تهيئته في initState
  late Stream<QuerySnapshot> _productsStream;

  @override
  void initState() {
    super.initState();
    // تشغيل جلب البيانات فور تحميل الصفحة
    _updateStream();
  }

  // دالة لتحديث قناة البيانات بناءً على القسم المختار
  void _updateStream() {
    setState(() {
      _productsStream = _databaseMethods.getSelectedData("products", "category", selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          /// --- القائمة الجانبية (Side Menu) ---
          Container(
            width: 240,
            color: Colors.deepPurple,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.card_giftcard, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text("متجر الهدايا", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                menuButton("المنتجات", Icons.shopping_bag, () {}),
                menuButton("الطلبات", Icons.receipt_long, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WebOrdersPage()));
                }),
                const Spacer(),
                menuButton("تسجيل الخروج", Icons.logout, () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                 await authService.signOut();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),

          /// --- المحتوى الرئيسي (Main Content) ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("إدارة المنتجات", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductPage()));
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text("إضافة منتج جديد", style: TextStyle(color: Colors.white, fontSize: 16)),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),

                  /// أزرار الفلترة حسب القسم
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        categoryButton("بوكسات هدايا جاهزه"),
                        categoryButton("توزيعات"),
                        categoryButton("عطور"),
                        categoryButton("بوكيهات ورد"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// عرض المنتجات باستخدام StreamBuilder
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productsStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text("لا توجد منتجات في هذا القسم حالياً", style: TextStyle(fontSize: 18, color: Colors.grey)),
                          );
                        }

                        var docs = snapshot.data!.docs;

                        return GridView.builder(
                          itemCount: docs.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.65, // تعديل النسبة لتوفر مساحة مريحة للوصف والأزرار
                          ),
                          itemBuilder: (context, index) {
                            var data = docs[index].data() as Map<String, dynamic>;
                            String docId = docs[index].id;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.05))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // عرض الصورة المخزنة بصيغة Base64
                                  Expanded(
                                    flex: 4,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: data['image'] != null
                                          ? Image.memory(
                                        base64Decode(data['image']),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                          : Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            data['name'] ?? "بدون اسم",
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                            "${data['price']} ريال",
                                            style: const TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.w600)
                                        ),
                                        const SizedBox(height: 6),

                                        // --- عرض الوصف المعدل هنا ---
                                        Text(
                                          data['description'] != null && data['description'].toString().isNotEmpty
                                              ? data['description']
                                              : "لا يوجد وصف لهذا المنتج.",
                                          style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.3),
                                          maxLines: 2, // يظهر سطرين كحد أقصى للحفاظ على التصميم العام
                                          overflow: TextOverflow.ellipsis, // يضع ثلاث نقاط (...) إذا كان الوصف أطول من سطرين
                                        ),
                                        const SizedBox(height: 12),

                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(
                                                      builder: (_) => EditProductPage(product: data, id: docId)));
                                                },
                                                child: const Text("تعديل"),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                                              onPressed: () => _confirmDelete(docId),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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

  // دالة تأكيد الحذف
  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("حذف منتج"),
        content: const Text("هل أنت متأكد من رغبتك في حذف هذا المنتج نهائياً؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("إلغاء")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _databaseMethods.deleteData("products", id);
              if (!mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم الحذف بنجاح")));
            },
            child: const Text("حذف الآن", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget menuButton(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
    );
  }

  Widget categoryButton(String title) {
    bool isSelected = selectedCategory == title;
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: isSelected ? 4 : 0,
          backgroundColor: isSelected ? Colors.deepPurple : Colors.white,
          side: BorderSide(color: isSelected ? Colors.deepPurple : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () {
          selectedCategory = title;
          _updateStream(); // إعادة تشغيل الـ Stream للقسم الجديد
        },
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
      ),
    );
  }
}