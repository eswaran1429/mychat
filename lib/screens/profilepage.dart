import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_api/src/request/model/uploader_params.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final ImagePicker _imagePicker = ImagePicker(); // Removed `?`

  // var cloud = Cloudinary.fromStringUrl(cloudinaryUrl)

  Future<void> pickImage() async {
    // Request permission based on Android version
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final profile = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (profile != null) {
        setState(() {
          image = File(profile.path);
        });
      }
    } else {
      print("Permission denied");
    }
  }

  // Future<void> cloudUpload() async{
  //   var response = 
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Image.file(image!, height: 150)
                : const Text('No Image Selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
          ],
        ),
      ),
    );
  }
}
