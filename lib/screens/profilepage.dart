import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychat/service/authservice.dart';
import 'package:mychat/service/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? image;
  final ImagePicker _imagePicker = ImagePicker(); // Removed `?`
  String imageUrl = '';
  String cloudName = 'dfc5mnnqi';
  late Database _database;

  String? profile;
  Future<String?> getProfile(String userId) async {
    profile = await _database.getProfile(userId);
    return profile;
  }

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
    } else {}
  }

  Future<void> cloudUpload(File image) async {
    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = 'user_profiles'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);

      setState(() {
        imageUrl = data['secure_url'];
        _database.addProfile(data['secure_url']);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Authservice>(context);
    _database = Database(uid: user.currentUser!.uid);
    return Scaffold(
  appBar: AppBar(
    title: const Text("Profile Page"),
    centerTitle: true,
    backgroundColor: Colors.blueAccent,
  ),
  body: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    color: Colors.grey[100],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FutureBuilder<String?>(
                  future: getProfile(user.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: Colors.blueAccent);
                    }

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 130,
                        backgroundImage: NetworkImage(snapshot.data!),
                        backgroundColor: Colors.grey[200],
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blueAccent,
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your Profile Picture",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: pickImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.upload),
          label: const Text(
            'Upload Image',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  ),
);

  }
}
