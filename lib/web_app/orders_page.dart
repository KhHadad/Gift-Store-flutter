import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  List<Map<String, dynamic>> orders = [

    {
      "name": "أحمد محمد",
      "phone": "777111222",
      "product": "بوكس شوكولاتة",
      "price": 120,
      "status": "جديد",
      "accepted": false,
      "step": 0,
    },

    {
      "name": "سارة علي",
      "phone": "777333444",
      "product": "كوب باسم",
      "price": 45,
      "status": "جديد",
      "accepted": false,
      "step": 0,
    },

    {
      "name": "ريم خالد",
      "phone": "777555666",
      "product": "شمعة عطرية",
      "price": 25,
      "status": "جديد",
      "accepted": false,
      "step": 0,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "الطلبات",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView.builder(
          itemCount: orders.length,

          itemBuilder: (context, index) {

            var order = orders[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 15),

              child: Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    /// الاسم + الرقم
                    Text(
                      "${order["name"]} - ${order["phone"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text("الطلب: ${order["product"]}"),
                    Text("السعر الإجمالي: ${order["price"]} ريال"),

                    const SizedBox(height: 10),

                    /// إذا لم يتم القبول
                    if (order["accepted"] == false)

                      Row(
                        children: [

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              setState(() {
                                order["accepted"] = true;
                                order["step"] = 1;
                                order["status"] = "قيد التجهيز";
                              });
                            },
                            child: const Text("قبول"),
                          ),

                          const SizedBox(width: 10),

                          /// زر رفض (يتحول رمادي بعد الضغط)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  order["status"] == "مرفوض"
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                order["status"] = "مرفوض";
                                order["accepted"] = false;
                              });
                            },
                            child: const Text("رفض"),
                          ),
                        ],
                      )

                    /// بعد القبول
                    else

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          const SizedBox(height: 10),

                          Wrap(
                            spacing: 10,
                            children: [

                              stepButton(order, "قيد التجهيز", 1),
                              stepButton(order, "تم الشحن", 2),
                              stepButton(order, "تم التسليم", 3),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "الحالة الحالية: ${order["status"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// زر المراحل (تجهيز → شحن → تسليم)
  Widget stepButton(
      Map<String, dynamic> order,
      String text,
      int stepNumber,
  ) {

    bool isActive = order["step"] >= stepNumber;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.blue : Colors.grey,
      ),

      onPressed: () {
        setState(() {

          if (stepNumber == order["step"] + 1) {
            order["step"] = stepNumber;
            order["status"] = text;
          }
        });
      },

      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}