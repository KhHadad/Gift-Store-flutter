import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب ID المستخدم الحالي
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("تتبع حالة الطلب", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF6A1B9A),
        centerTitle: true,
        elevation: 0,
      ),
      body: user == null
          ? const Center(child: Text("يرجى تسجيل الدخول أولاً"))
          : StreamBuilder<QuerySnapshot>(
        // ملاحظة: تأكدي من تفعيل الـ Index في الفايربيس لهذا الاستعلام
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("userId", isEqualTo: user.uid)
            .orderBy("orderDate", descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("حدث خطأ: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF6A1B9A)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          var orderDoc = snapshot.data!.docs.first;
          var orderData = orderDoc.data() as Map<String, dynamic>;
          int step = orderData['step'] ?? 0;
          String status = orderData['status'] ?? "جديد";

          if (status == "مرفوض") {
            return _buildRejectedStatus();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // بطاقة معلومات الطلب السريعة
                _buildOrderSummaryCard(orderDoc.id, status),
                const SizedBox(height: 40),

                // رسم التايم لاين
                _buildTrackingStep("تم استلام الطلب", "نحن الآن نراجع تفاصيل طلبك", step >= 0, true),
                _buildConnector(step >= 1),
                _buildTrackingStep("قيد التجهيز", "يتم الآن تغليف هديتك بكل حب", step >= 1, step >= 1),
                _buildConnector(step >= 2),
                _buildTrackingStep("تم الشحن", "هديتك الآن في طريقها إليك", step >= 2, step >= 2),
                _buildConnector(step >= 3),
                _buildTrackingStep("تم التسليم", "نتمنى أن تنال الهدية إعجابكم", step >= 3, step >= 3),

                const SizedBox(height: 50),
                // زر العودة للرئيسية لتحسين التنقل
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6A1B9A),
                      side: const BorderSide(color: Color(0xFF6A1B9A)),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  child: const Text("العودة للتسوق"),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // --- ويدجت إضافية: ملخص الطلب ---
  Widget _buildOrderSummaryCard(String orderId, String status) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 5)],
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, size: 40, color: Color(0xFF6A1B9A)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("رقم الطلب: #${orderId.substring(0, 8)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("الحالة الحالية: $status", style: const TextStyle(color: Color(0xFFAD1457))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, bool isReached, bool isActive) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 35, height: 35,
          decoration: BoxDecoration(
            color: isReached ? const Color(0xFFAD1457) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: isReached ? const Color(0xFFAD1457) : Colors.grey.shade300, width: 2),
          ),
          child: Icon(Icons.check, size: 20, color: isReached ? Colors.white : Colors.grey.shade300),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isReached ? Colors.black : Colors.grey)),
              Text(subtitle, style: TextStyle(fontSize: 12, color: isReached ? Colors.black54 : Colors.grey.shade400)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 17), // محاذاة دقيقة للخط
      height: 35,
      width: 2,
      color: isActive ? const Color(0xFFAD1457) : Colors.grey.shade200,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          const Text("لا توجد طلبات جارية حالياً", style: TextStyle(color: Colors.grey, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildRejectedStatus() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 100, color: Colors.redAccent),
            const SizedBox(height: 20),
            const Text("عذراً، تم رفض الطلب", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("قد يكون السبب عدم توفر المنتج أو مشكلة في التوصيل. يرجى التواصل معنا.", textAlign: TextAlign.center),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}