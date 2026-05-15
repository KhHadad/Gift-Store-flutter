import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';

class ExcelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _convertToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // إضافة منتج يدوي
  Future<void> addManualProduct({
    required String name,
    required String price,
    required String category,
    required String description,
    required Uint8List imageBytes,
  }) async {
    String base64Image = _convertToBase64(imageBytes);
    await _firestore.collection('products').add({
      'name': name,
      'price': double.tryParse(price) ?? 0.0,
      'category': category,
      'description': description,
      'image': base64Image,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // المعالجة الجماعية (تم تعديل ترتيب الأعمدة هنا بناءً على صورتك)
  Future<void> processBulkImport(Uint8List excelBytes, Map<String, Uint8List> imagesMap) async {
    var excel = Excel.decodeBytes(excelBytes);
    var sheet = excel.tables[excel.tables.keys.first];

    if (sheet == null) return;

    for (var row in sheet.rows.skip(1)) {
      // بناءً على صورتك:
      // A (0) = image | B (1) = category | C (2) = price | D (3) = description | E (4) = name

      String imageName  = row[0]?.value?.toString() ?? "";
      String category   = row[1]?.value?.toString() ?? "";
      String price      = row[2]?.value?.toString() ?? "0";
      String description = row[3]?.value?.toString() ?? "";
      String name       = row[4]?.value?.toString() ?? "";

      // تنظيف اسم الصورة من أي مسافات زائدة
      imageName = imageName.trim();

      if (imagesMap.containsKey(imageName)) {
        String base64Img = _convertToBase64(imagesMap[imageName]!);

        await _firestore.collection('products').add({
          'name': name,
          'price': double.tryParse(price) ?? 0.0,
          'category': category,
          'description': description,
          'image': base64Img,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("✅ تم رفع المنتج: $name");
      } else {
        print("❌ لم يتم العثور على صورة باسم: '$imageName' في المرفقات");
      }
    }
  }
}