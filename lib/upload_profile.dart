import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  File? _image;
  final picker = ImagePicker();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      // Buat nama unik untuk gambar
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Upload gambar ke Firebase Storage
      UploadTask uploadTask =
          storage.ref('uploads/$fileName.jpg').putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;

      // Ambil URL gambar setelah upload
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Simpan URL ke Firestore
      await firestore.collection('users').add({
        'imageUrl': downloadUrl,
        // Anda bisa menambahkan informasi lain seperti username, dll.
      });

      print('Upload selesai! URL: $downloadUrl');
    } catch (e) {
      print('Error saat upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('Tidak ada gambar yang dipilih.')
                : Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pilih Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Upload Gambar'),
            ),
          ],
        ),
      ),
    );
  }
}
