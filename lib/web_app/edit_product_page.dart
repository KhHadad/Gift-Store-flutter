import 'dart:convert'; // ضروري جداً لتشفيير وفك تشفير الـ Base64
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart'; // نفس المكتبة المستخدمة في مشروعك لاستيراد الصور وبايتاتها

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final String id; // الـ ID الفريد للمستند القادم من صفحة العرض الرئيسية

  const EditProductPage({super.key, required this.product, required this.id});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descController;
  late String selectedCategory;

  // المتغيرات الخاصة بالصورة الجديدة المحددة والقديمة المشفرة
  Uint8List? newImageBytes;
  String? currentBase64Image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // تعبئة البيانات الحالية داخل الحقول لتعديلها
    nameController = TextEditingController(text: widget.product["name"]);
    priceController = TextEditingController(text: widget.product["price"]?.toString());
    descController = TextEditingController(text: widget.product["description"]);
    selectedCategory = widget.product["category"] ?? "بوكسات هدايا جاهزة";

    // جلب نص الصورة المشفرة الحالية من الفايرستور (حقل image)
    currentBase64Image = widget.product["image"];
  }

  // دالة اختيار صورة جديدة من المعرض بصيغة الـ Bytes (تتوافق مع الويب والموبايل)
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        newImageBytes = result.files.single.bytes;
      });
    }
  }

  // دالة الحفظ والتعديل الفعلي في الفايرستور باستخدام الـ ID بدقة 🔥
  Future<void> _updateProductInFirebase() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى كتابة اسم المنتج"), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String finalBase64Image = currentBase64Image ?? "";

      // إذا اختار المستخدم صورة جديدة، نقوم بتحويل الـ Bytes إلى نص Base64 مشفر
      if (newImageBytes != null) {
        finalBase64Image = base64Encode(newImageBytes!);
      }

      // الاتصال المباشر بالوثيقة عبر معرفها الـ id وتحديثها بالكامل
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id) // التحديث يستهدف هذا المستند بدقة 🔥
          .update({
        'name': nameController.text.trim(),
        'price': double.tryParse(priceController.text) ?? 0.0,
        'category': selectedCategory,
        'description': descController.text.trim(),
        'image': finalBase64Image, // حفظ الرابط النصي المشفر الجديد أو القديم
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تحديث بيانات المنتج بنجاح"), backgroundColor: Colors.green),
      );

      Navigator.pop(context); // العودة التلقائية لصفحة المنتجات الرئيسية
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء حفظ التعديل: $e"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("تعديل المنتج", style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : Center(
        child: Container(
          width: 600, // لتناسق حجم الشاشة إن فتحت لوحة التحكم من متصفح ويب أو تابلت
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                // --- قسم معاينة وتعديل الصورة بنظام الـ Base64 ---
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[50],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: newImageBytes != null
                              ? Image.memory(newImageBytes!, fit: BoxFit.cover) // إذا اختار صورة جديدة يعرض بايتاتها
                              : (currentBase64Image != null && currentBase64Image!.isNotEmpty)
                              ? Image.memory(base64Decode(currentBase64Image!), fit: BoxFit.cover) // عرض وفك تشفير الصورة المخزنة حالياً بالفايرستور
                              : Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text("اضغط على الصورة لتغييرها والتحميل من الجهاز", style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 35),

                // --- الحقول النصية لإدخال البيانات المحدثة ---
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "اسم المنتج", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: "السعر (ريال)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: "القسم", border: OutlineInputBorder()),
                  items: ["بوكسات هدايا جاهزة", "توزيعات", "عطور", "بوكيهات ورد"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "الوصف", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 35),

                // --- زر حفظ البيانات والتحديث الفعلي ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _updateProductInFirebase,
                    child: const Text(
                      "حفظ التعديلات الحالية",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}