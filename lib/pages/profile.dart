import 'package:flutter/material.dart';
import 'dart:io';
import '../data/database.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ToDoDataBase _database = ToDoDataBase();
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Update the image file state
      File newImageFile = File(pickedFile.path);

      ProfileInfo updatedProfileInfo = ProfileInfo(
        fullName: _database.loadProfileInfo().fullName,
        name: _database.loadProfileInfo().name,
        major: _database.loadProfileInfo().major,
        dateOfBirth: _database.loadProfileInfo().dateOfBirth,
        email: _database.loadProfileInfo().email,
        profileImagePath: newImageFile.path,
        hobby: _database.loadProfileInfo().hobby,
        socialMedia: _database.loadProfileInfo().socialMedia,
      );

      _database.saveProfileInfo(updatedProfileInfo);

      // Update the UI
      setState(() {
        _imageFile = newImageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileInfo = _database.loadProfileInfo();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 104, 156),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 16, 104, 156),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEFFEFF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(55),
                  topRight: Radius.circular(55),
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.0, 45.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : (profileInfo.profileImagePath.isNotEmpty
                                      ? FileImage(
                                          File(profileInfo.profileImagePath))
                                      : null),
                              child: _imageFile == null &&
                                      profileInfo.profileImagePath.isEmpty
                                  ? const Icon(Icons.camera_alt,
                                      size: 50, color: Colors.blue)
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildProfileField('Full Name', profileInfo.fullName),
                    _buildProfileField('Nickname', profileInfo.name),
                    _buildProfileField('Major', profileInfo.major),
                    _buildProfileField(
                        'Date of Birth', profileInfo.dateOfBirth),
                    _buildProfileField('Email', profileInfo.email),
                    _buildProfileField('Hobby', profileInfo.hobby),
                    _buildProfileField('Instagram', profileInfo.socialMedia),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfileField(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFBDBDBD)),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ],
    ),
  );
}
