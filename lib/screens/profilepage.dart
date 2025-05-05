import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final ImagePicker _imagePicker = ImagePicker(); // Removed `?`
  String imageUrl ='';
  String cloudName = 'dfc5mnnqi';

  Future<void> pickImage() async {
    // Request permission based on Android version
    if (await Permission.photos.request().isGranted ||
        await Permission.storage.request().isGranted) {
      final profile = await _imagePicker.pickImage(source: ImageSource.gallery);

      if (profile != null) {
        setState(() {
          image = File(profile.path);
          cloudUpload(image!);
        });
      }
    } else {
      print("Permission denied");
    }
  }

  Future<void> cloudUpload(File image) async{
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset']= 'user_profiles'
    ..files.add(await http.MultipartFile.fromPath('file', image.path)); 

    final response = await request.send();

    if(response.statusCode == 200){
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);

      setState(() {
        imageUrl = data['secure_url'];
        print('uploaded $imageUrl');
      });
    }else{
      print('Upload failed');
    }
  }

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
