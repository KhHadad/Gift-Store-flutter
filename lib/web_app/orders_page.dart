import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WebOrdersPage extends StatefulWidget {
  const WebOrdersPage({super.key});

  @override
  State<WebOrdersPage> createState() => _WebOrdersPageState();
}

class _WebOrdersPageState extends State<WebOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A148C),
        elevation: 0,
        title: const Text("لوحة التحكم | إدارة الطلبات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh, color: Colors.white)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // جلب أحدث الطلبات أولاً في الويب
        stream: FirebaseFirestore.instance.collection("orders").orderBy("orderDate", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFF4A148C)));

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد طلبات حتى الآن"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var orderData = doc.data() as Map<String, dynamic>;
              String userId = orderData['userId'] ?? "";

              return _buildOrderCard(doc.id, orderData, userId);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(String orderId, Map<String, dynamic> orderData, String userId) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          // 1. رأس الكارد: بيانات المستخدم (تجلب من مجموعة users)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: _getStatusColor(orderData['status']).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection("users").doc(userId).get(),
              builder: (context, userSnapshot) {
                String userName = "جاري التحميل...";
                String userPhone = "...";

                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  userName = userData['name'] ?? "بدون اسم";
                  userPhone = userData['phone'] ?? "بدون هاتف";
                }

                return Row(
                  children: [
                    const CircleAvatar(backgroundColor: Color(0xFF4A148C), child: Icon(Icons.person, color: Colors.white)),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("هاتف: $userPhone | طلب رقم: #$orderId", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    const Spacer(),
                    _buildStatusChip(orderData['status']),
                  ],
                );
              },
            ),
          ),

          // 2. محتوى الطلب: المنتجات
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("المنتجات المطلوبة:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ...(orderData['items'] as List).map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text("${item['name']} (عدد: ${item['quantity']})"),
                    ],
                  ),
                )),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("الإجمالي: ${orderData['totalPrice']} ريال",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFAD1457))),
                    _buildControlButtons(orderId, orderData),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // أزرار التحكم في الحالات
  Widget _buildControlButtons(String docId, Map<String, dynamic> data) {
    if (data['status'] == "جديد") {
      return Row(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => _updateStatus(docId, "قيد التجهيز", 1, true),
            child: const Text("قبول الطلب", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: () => _updateStatus(docId, "مرفوض", 0, false),
            child: const Text("رفض الطلب", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    } else if (data['status'] == "مرفوض") {
      return const Text("تم رفض هذا الطلب", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    } else {
      // أزرار المراحل
      return Wrap(
        spacing: 8,
        children: [
          _stepActionBtn(docId, "قيد التجهيز", 1, data['step']),
          _stepActionBtn(docId, "تم الشحن", 2, data['step']),
          _stepActionBtn(docId, "تم التسليم", 3, data['step']),
        ],
      );
    }
  }

  Widget _stepActionBtn(String id, String text, int step, int currentStep) {
    bool isCurrentOrPast = currentStep >= step;
    return ChoiceChip(
      label: Text(text),
      selected: isCurrentOrPast,
      onSelected: (val) {
        if (val) _updateStatus(id, text, step, true);
      },
      selectedColor: Colors.blue[100],
      labelStyle: TextStyle(color: isCurrentOrPast ? Colors.blue[900] : Colors.grey),
    );
  }

  void _updateStatus(String docId, String status, int step, bool accepted) {
    FirebaseFirestore.instance.collection("orders").doc(docId).update({
      "status": status,
      "step": step,
      "accepted": accepted,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("تم تحديث الطلب إلى: $status"), backgroundColor: Colors.black87),
      );
    });
  }

  // تحسينات الألوان والحالات
  Color _getStatusColor(String? status) {
    switch (status) {
      case "جديد": return Colors.orange;
      case "قيد التجهيز": return Colors.blue;
      case "تم الشحن": return Colors.purple;
      case "تم التسليم": return Colors.green;
      case "مرفوض": return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildStatusChip(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status ?? "غير معروف", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}