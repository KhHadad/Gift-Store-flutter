import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            /// زر رفع ملف اكسل
            ElevatedButton.icon(

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green,
              ),

              onPressed: () async {

                FilePickerResult? result =
                    await FilePicker
                        .platform
                        .pickFiles(

                  type: FileType.custom,

                  allowedExtensions: [
                    'xlsx',
                    'xls'
                  ],
                );

                if (result != null) {

                  String fileName =
                      result
                          .files
                          .single
                          .name;

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(

                    SnackBar(
                      content: Text(
                        "تم اختيار الملف: $fileName",
                      ),
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

                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// اسم المنتج
            TextField(

              controller:
                  nameController,

              decoration:
                  InputDecoration(

                labelText:
                    "اسم المنتج",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// السعر
            TextField(

              controller:
                  priceController,

              decoration:
                  InputDecoration(

                labelText: "السعر",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// الوصف
            TextField(

              controller:
                  descController,

              maxLines: 3,

              decoration:
                  InputDecoration(

                labelText: "الوصف",

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// زر الحفظ
            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.deepPurple,
                ),

                onPressed: () {

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(

                    const SnackBar(
                      content: Text(
                        "تم حفظ المنتج بنجاح",
                      ),
                    ),
                  );
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