import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,

        title: const Text(
          "الطلبات",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          children: [

            orderTile(
              "أحمد محمد",
              "بوكس شوكولاتة",
              "قيد المعالجة",
            ),

            orderTile(
              "سارة علي",
              "كوب باسم",
              "تم التوصيل",
            ),

            orderTile(
              "ريم خالد",
              "شمعة عطرية",
              "ملغي",
            ),
          ],
        ),
      ),
    );
  }

  Widget orderTile(
      String name,
      String product,
      String status,
      ) {

    return Card(

      child: ListTile(

        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,

          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),

        title: Text(name),

        subtitle: Text(product),

        trailing: Text(
          status,

          style: TextStyle(

            color:
            status == "تم التوصيل"
                ? Colors.green
                : status == "ملغي"
                ? Colors.red
                : Colors.orange,
          ),
        ),
      ),
    );
  }
}