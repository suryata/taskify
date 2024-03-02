import 'package:hive_flutter/hive_flutter.dart';

class ProfileInfo {
  String name;
  String major;
  String dateOfBirth;
  String email;
  String profileImagePath;

  ProfileInfo({
    required this.name,
    required this.major,
    required this.dateOfBirth,
    required this.email,
    required this.profileImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'major': major,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'profileImagePath': profileImagePath,
    };
  }

  static ProfileInfo fromMap(Map<String, dynamic> map) {
    return ProfileInfo(
      name: map['name'],
      major: map['major'],
      dateOfBirth: map['dateOfBirth'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
    );
  }
}

class ToDoDataBase {
  List toDoList = [];
  final _myBox = Hive.box('mybox');

  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Do Exercise", false],
    ];
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST") ?? [];
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }

  // Fungsi untuk menyimpan info profil
  void saveProfileInfo(ProfileInfo profileInfo) {
    _myBox.put('profileInfo', profileInfo.toMap());
  }

  // Fungsi untuk memuat info profil
  ProfileInfo loadProfileInfo() {
    var profileMap = _myBox.get('profileInfo', defaultValue: {
      'name': 'Nama Anda',
      'major': 'Jurusan Anda',
      'dateOfBirth': 'Tanggal Lahir Anda',
      'email': 'Email Anda',
      'profileImagePath': '',
    });
    return ProfileInfo.fromMap(profileMap);
  }
}
