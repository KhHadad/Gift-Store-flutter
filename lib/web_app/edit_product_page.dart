import 'package:flutter/material.dart';

class EditProductPage extends StatelessWidget {
  const EditProductPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "تعديل البيانات",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          children: [

            TextField(
              decoration: InputDecoration(
                hintText: "اسم المنتج",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              decoration: InputDecoration(
                hintText: "السعر",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              maxLines: 4,

              decoration: InputDecoration(
                hintText: "الوصف",

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor:
                Colors.deepPurple,
              ),

              onPressed: () {},

              child: const Text(
                "حفظ التعديلات",
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