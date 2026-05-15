import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // إضافة أو تحديث بيانات
  Future addOrUpdateData(Map<String, dynamic> dataMap, String id, String collection) async {
    return await _db.collection(collection).doc(id).set(dataMap, SetOptions(merge: true));
  }

  // جلب كل البيانات (Stream)
  Stream<QuerySnapshot> getAllData(String collection) {
    return _db.collection(collection).snapshots();
  }

  // البحث عن بيانات محددة
  Stream<QuerySnapshot> getSelectedData(String collection, String field, String value) {
    return _db.collection(collection).where(field, isEqualTo: value).snapshots();
  }

  // حذف بيانات
  Future deleteData(String collection, String id) async {
    return await _db.collection(collection).doc(id).delete();
  }
}