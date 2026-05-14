import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductPage({super.key, required this.product});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.product["name"]);

    priceController =
        TextEditingController(text: widget.product["price"]);

    descController =
        TextEditingController(text: widget.product["description"]);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "تعديل البيانات",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "اسم المنتج",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: "السعر",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "الوصف",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),

              onPressed: () {

                setState(() {
                  widget.product["name"] = nameController.text;
                  widget.product["price"] = priceController.text;
                  widget.product["description"] = descController.text;
                });

                Navigator.pop(context);
              },

              child: const Text(
                "حفظ التعديلات",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}