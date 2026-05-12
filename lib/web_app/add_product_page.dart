import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {

  AddProductPage({super.key});

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController priceController =
  TextEditingController();

  final TextEditingController descController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "إضافة منتج",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// زر Excel
            ElevatedButton.icon(

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.green,
              ),

              onPressed: () {},

              icon: const Icon(
                Icons.upload_file,
                color: Colors.white,
              ),

              label: const Text(
                "إضافة ملف Excel",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "اسم المنتج",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "السعر",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: "الوصف",
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.deepPurple,
              ),

              onPressed: () {},

              child: const Text(
                "حفظ",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}