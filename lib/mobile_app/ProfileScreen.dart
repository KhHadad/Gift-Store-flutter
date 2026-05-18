import 'package:flutter/material.dart';
import '../firebaseAuthService.dart';
import 'Products.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // 1. إنشاء كائن من خدمة الـ AuthService للوصول لدوال الفايربيس
  final AuthService _authService = AuthService();

  // متغير للتحكم بحالة التحميل أثناء الرفع للفايربيس
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("البيانات الشخصية", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A148C),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Color(0xFF4A148C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person_add_alt_1, size: 50, color: Color(0xFF7B1FA2)),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("يرجى إكمال بياناتكِ لتسهيل عملية التوصيل:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A148C))),
                      const SizedBox(height: 25),

                      _buildInputField(
                        controller: _nameController,
                        label: "الاسم الكامل",
                        icon: Icons.person_outline,
                        hint: "أدخلي اسمكِ الثلاثي",
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        controller: _addressController,
                        label: "عنوان السكن",
                        icon: Icons.location_on_outlined,
                        hint: "المدينة، الحي، الشارع",
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        controller: _phoneController,
                        label: "رقم الجوال",
                        icon: Icons.phone_android_outlined,
                        hint: "05xxxxxxxx",
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 40),

                      // 2. تحديث الزر ليقوم بعملية الحفظ في الفايربيس
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFF7B1FA2)))
                            : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true); // بدء التحميل

                              try {
                                // استدعاء دالة الرفع التي تربط البيانات بالـ UID تلقائياً
                                await _authService.uploadProfileData(
                                  _nameController.text.trim(),
                                  _phoneController.text.trim(),
                                  _addressController.text.trim(),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("تم حفظ بياناتكِ في الفايربيس بنجاح", textAlign: TextAlign.right),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                // هنا يمكنك الانتقال لصفحة المنتجات
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsDisplayScreen()));

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
                                );
                              } finally {
                                setState(() => _isLoading = false); // إيقاف التحميل
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B1FA2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 3,
                          ),
                          child: const Text("حفظ ومتابعة",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 2. تحديث الزرللانتقال
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child:ElevatedButton(
                          onPressed: () {

                            // هنا يمكنك الانتقال لصفحة المنتجات
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductsDisplayScreen()));

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B1FA2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 3,
                          ),
                          child: const Text("سجلت مسبقا",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF7B1FA2), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFFAB47BC)),
            filled: true,
            fillColor: const Color(0xFFF3E5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          ),
          validator: (value) => value!.isEmpty ? "هذا الحقل مطلوب" : null,
        ),
      ],
    );
  }
}