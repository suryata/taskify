// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:taskify/pages/page_controller.dart';
import 'landing.dart';
import '../data/database.dart';

class ProfileInputPage extends StatefulWidget {
  const ProfileInputPage({Key? key}) : super(key: key);

  @override
  _ProfileInputPageState createState() => _ProfileInputPageState();
}

class _ProfileInputPageState extends State<ProfileInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _socialMediaController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  File? _imageFile;
  final ToDoDataBase _database = ToDoDataBase();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = pickedFile.name;
      final savedImage =
          await File(pickedFile.path).copy('${directory.path}/$fileName');

      setState(() {
        _imageFile = savedImage;
      });
    }
  }

  Future<void> _pickDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveProfileAndNavigate() {
    if (_formKey.currentState!.validate()) {
      final profileInfo = ProfileInfo(
        name: _nameController.text,
        major: _majorController.text,
        dateOfBirth: _dobController.text,
        email: _emailController.text,
        profileImagePath: _imageFile?.path ?? '',
        fullName: _fullNameController.text,
        hobby: _hobbyController.text,
        socialMedia: _socialMediaController.text, // Menyimpan Instagram
      );

      _database.saveProfileInfo(profileInfo);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PageControllers()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFEFF),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Landing())),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              const SizedBox(height: 35),
              _buildTextFormField(
                  label: 'Full Name',
                  controller: _fullNameController), // Field untuk fullName
              _buildTextFormField(
                  label: 'Nickname', controller: _nameController),
              _buildTextFormField(label: 'Major', controller: _majorController),
              _buildTextFormField(
                  label: 'Date of Birth',
                  controller: _dobController,
                  onTap: _pickDateOfBirth),
              _buildTextFormField(
                label: 'Email',
                controller: _emailController,
                customValidator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                  label: 'Instagram', controller: _socialMediaController),
              _buildTextFormField(label: 'Hobby', controller: _hobbyController),
              const SizedBox(height: 45),
              ElevatedButton(
                onPressed: _saveProfileAndNavigate,
                child: const Text('Save Profile'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    VoidCallback? onTap,
    String? Function(String?)? customValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        readOnly: onTap != null,
        onTap: onTap,
        validator: customValidator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            },
      ),
    );
  }
}
