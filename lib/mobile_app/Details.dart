import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // تأكدي من إضافة هذا الاستيراد
import '../DatabaseMethods.dart';
import 'TrakingOrders.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseMethods _db = DatabaseMethods();
  bool _isProcessing = false; // لإظهار مؤشر تحميل ومنع الضغط المتكرر

  double calculateTotal() {
    double total = 0;
    for (var item in widget.cartItems) {
      // التأكد من تحويل القيم إلى double لتجنب أخطاء النوع
      double price = double.parse(item['price'].toString());
      int qty = int.parse(item['quantity'].toString());
      total += (price * qty);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("سلة المشتريات", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6A1B9A),
        centerTitle: true,
      ),
      body: widget.cartItems.isEmpty
          ? const Center(child: Text("سلتكِ فارغة حالياً"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("الكمية: ${item['quantity']} - السعر: ${item['price']} ريال"),
                    trailing: Text("${(item['price'] * item['quantity'])} ريال",
                        style: const TextStyle(color: Color(0xFFAD1457), fontWeight: FontWeight.bold)),
                  ),
                );
              },
            ),
          ),
          _buildCheckoutSection(),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${calculateTotal()} ريال",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFAD1457))),
              const Text("الإجمالي:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: _isProcessing
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFAD1457)))
                : ElevatedButton(
              onPressed: () async {
                await _processOrder();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAD1457),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: const Text("تأكيد الطلب الآن", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // --- وظيفة معالجة الطلب وإرساله للفايربيس ---
  Future<void> _processOrder() async {
    setState(() => _isProcessing = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      // التعديل المهم: تنظيف البيانات من الـ Base64 قبل الرفع
      // الفايربيس لا يفضل تخزين نصوص ضخمة جداً (الصور) داخل قائمة الطلبات
      List<Map<String, dynamic>> cleanedItems = widget.cartItems.map((item) {
        return {
          "name": item['name'],
          "price": item['price'],
          "quantity": item['quantity'],
          "productId": item['id'], // معرف المنتج للرجوع إليه لاحقاً
          // نتجنب رفع حقل 'image' هنا لتقليل حجم الوثيقة وسرعة التطبيق
        };
      }).toList();

      Map<String, dynamic> orderData = {
        "userId": user.uid,
        "items": cleanedItems, // القائمة النظيفة
        "totalPrice": calculateTotal(),
        "status": "جديد",
        "step": 0,
        "accepted": false,
        "orderDate": FieldValue.serverTimestamp(), // استخدام توقيت السيرفر لضمان الدقة
      };

      await _db.addOrUpdateData(orderData, orderId, "orders");

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم تأكيد طلبك بنجاح!")));

      // الانتقال لتتبع الطلب وإفراغ السلة
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderTrackingScreen())
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("حدث خطأ: $e")));
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}