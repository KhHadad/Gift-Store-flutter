import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // تعريف وحدات التحكم للنصوص لجلب البيانات لاحقاً
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar بسيط بنفسجي غامق
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
            // الجزء العلوي: خلفية بنفسجية مع أيقونة الملف الشخصي
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("يرجى إكمال بياناتكِ لتسهيل عملية التوصيل:",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A148C))),
                    const SizedBox(height: 25),

                    // حقل الاسم الكامل
                    _buildInputField(
                      controller: _nameController,
                      label: "الاسم الكامل",
                      icon: Icons.person_outline,
                      hint: "أدخلي اسمكِ الثلاثي",
                    ),
                    const SizedBox(height: 20),

                    // حقل العنوان
                    _buildInputField(
                      controller: _addressController,
                      label: "عنوان السكن",
                      icon: Icons.location_on_outlined,
                      hint: "المدينة، الحي، الشارع",
                    ),
                    const SizedBox(height: 20),

                    // حقل رقم الهاتف
                    _buildInputField(
                      controller: _phoneController,
                      label: "رقم الجوال",
                      icon: Icons.phone_android_outlined,
                      hint: "05xxxxxxxx",
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 40),

                    // زر حفظ البيانات بتنسيق بنفسجي زاهي
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // هنا سيتم الانتقال لصفحة عرض المنتجات لاحقاً
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم حفظ البيانات بنجاح")),
                            );
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصصة لبناء حقول الإدخال بشكل موحد وجميل
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
            fillColor: const Color(0xFFF3E5F5), // بنفسجي فاتح جداً للخلفية
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
