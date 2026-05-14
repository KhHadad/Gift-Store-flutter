import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {

  String selectedCategory = "بوكسات هدايا جاهزة";

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "إضافة منتج",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// زر رفع ملف اكسل
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),

              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx', 'xls'],
                );

                if (result != null) {
                  String fileName = result.files.single.name;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("تم اختيار الملف: $fileName"),
                    ),
                  );
                }
              },

              icon: const Icon(
                Icons.upload_file,
                color: Colors.white,
              ),

              label: const Text(
                "إضافة ملف اكسل",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 30),

            /// اسم المنتج
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "اسم المنتج",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// السعر
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: "السعر",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// نوع المنتج
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: InputDecoration(
                labelText: "نوع المنتج",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              items: [
                "بوكسات هدايا جاهزة",
                "توزيعات",
                "عطور",
                "بوكيهات ورد",
              ].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// الوصف
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "الوصف",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),

                onPressed: () {

                  /// 1. التحقق من البيانات
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty ||
                      descController.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("رجاءً عبّي كل الحقول"),
                      ),
                    );
                    return;
                  }

                  /// 2. إنشاء المنتج الجديد
                  Map<String, dynamic> newProduct = {
                    "name": nameController.text,
                    "price": priceController.text,
                    "category": selectedCategory,
                    "description": descController.text,
                  };

                  /// 3. رجّع المنتج للصفحة السابقة
                  Navigator.pop(context, newProduct);

                  /// 4. رسالة نجاح (اختياري)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("تم حفظ المنتج بنجاح"),
                    ),
                  );

                  /// 5. تنظيف الحقول
                  nameController.clear();
                  priceController.clear();
                  descController.clear();
                },

                child: const Text(
                  "حفظ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}