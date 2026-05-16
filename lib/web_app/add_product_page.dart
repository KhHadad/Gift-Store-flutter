import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'ExcelService.dart';


class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final ExcelService _excelService = ExcelService();

  // متغيرات لتخزين الصور الجماعية مؤقتاً
  Map<String, Uint8List> bulkImages = {};

  // متغيرات المنتج اليدوي
  Uint8List? manualImageBytes;
  String selectedCategory = "بوكسات هدايا جاهزة";
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("إدارة المنتجات", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        //child
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("🛒 الاستيراد الجماعي (خطوتين):", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                // الخطوة 1: اختيار الصور
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        allowMultiple: true,
                        type: FileType.image,
                      );
                      if (result != null) {
                        setState(() {
                          for (var file in result.files) {
                            if (file.bytes != null) bulkImages[file.name] = file.bytes!;
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم تجهيز ${bulkImages.length} صورة")),
                        );
                      }
                    },
                    icon: const Icon(Icons.photo_library, color: Colors.white),
                    label: const Text("1. اختر الصور", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                // الخطوة 2: رفع الإكسل والبدء
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bulkImages.isEmpty ? Colors.grey : Colors.green,
                    ),
                    onPressed: bulkImages.isEmpty ? null : () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx', 'xls'],
                      );
                      if (result != null) {
                        await _excelService.processBulkImport(result.files.single.bytes!, bulkImages);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تمت عملية الرفع بنجاح!")),
                        );
                      }
                    },
                    icon: const Icon(Icons.file_present, color: Colors.white),
                    label: const Text("2. ارفع الإكسل", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            const Divider(height: 50, thickness: 2),

            const Text("➕ إضافة منتج يدوي:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // معاينة صورة المنتج اليدوي
            Center(
              child: InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result != null) {
                    setState(() => manualImageBytes = result.files.single.bytes);
                  }
                },
                child: Container(
                  height: 120, width: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[100],
                  ),
                  child: manualImageBytes == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.memory(manualImageBytes!, fit: BoxFit.cover)),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "اسم المنتج", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "السعر", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: "القسم", border: OutlineInputBorder()),
              items: ["بوكسات هدايا جاهزة", "توزيعات", "عطور", "بوكيهات ورد"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedCategory = v!),
            ),
            const SizedBox(height: 15),
            TextField(controller: descController, maxLines: 2, decoration: const InputDecoration(labelText: "الوصف", border: OutlineInputBorder())),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () async {
                  if (nameController.text.isEmpty || manualImageBytes == null) return;
                  await _excelService.addManualProduct(
                    name: nameController.text,
                    price: priceController.text,
                    category: selectedCategory,
                    description: descController.text,
                    imageBytes: manualImageBytes!,
                  );
                  Navigator.pop(context);
                },
                child: const Text("حفظ المنتج اليدوي", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}