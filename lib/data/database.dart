import 'package:hive_flutter/hive_flutter.dart';

class ProfileInfo {
  String name;
  String major;
  String dateOfBirth;
  String email;
  String profileImagePath;
  String fullName;
  String hobby;
  String socialMedia;

  ProfileInfo({
    required this.name,
    required this.major,
    required this.dateOfBirth,
    required this.email,
    required this.profileImagePath,
    required this.fullName,
    required this.hobby,
    required this.socialMedia,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'major': major,
      'dateOfBirth': dateOfBirth,
      'email': email,
      'profileImagePath': profileImagePath,
      'fullName': fullName,
      'hobby': hobby,
      'socialMedia': socialMedia,
    };
  }

  static ProfileInfo fromMap(Map<String, dynamic> map) {
    return ProfileInfo(
      name: map['name'],
      major: map['major'],
      dateOfBirth: map['dateOfBirth'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
      fullName: map['fullName'],
      hobby: map['hobby'],
      socialMedia: map['socialMedia'],
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  DateTime startDate;
  DateTime endDate;
  String category;
  String description;

  Task({
    required this.title,
    this.isCompleted = false,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'category': category,
      'description': description,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      isCompleted: map['isCompleted'] ?? false,
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      category: map['category'],
      description: map['description'],
    );
  }
}

class ToDoDataBase {
  Box<dynamic> _myBox = Hive.box('mybox');

  void addTask(Task task) {
    final taskMap = {
      'title': task.title,
      'startDate': task.startDate.toIso8601String(),
      'endDate': task.endDate.toIso8601String(),
      'category': task.category,
      'description': task.description,
      'isCompleted': task.isCompleted,
    };
    _myBox.add(taskMap);
  }

  void updateTask(int index, Task task) {
    final taskMap = {
      'title': task.title,
      'startDate': task.startDate.toIso8601String(),
      'endDate': task.endDate.toIso8601String(),
      'category': task.category,
      'description': task.description,
      'isCompleted': task.isCompleted,
    };
    _myBox.putAt(index, taskMap);
  }

  void deleteTask(int index) {
    _myBox.deleteAt(index);
  }

  List<Task> getTasks() {
    return _myBox.values
        .where(
            (element) => element is Map && element['title']?.isNotEmpty == true)
        .map((e) => Task(
              title: e['title'],
              isCompleted: e['isCompleted'] ?? false,
              startDate: DateTime.parse(e['startDate']),
              endDate: DateTime.parse(e['endDate']),
              category: e['category'] ?? '',
              description: e['description'] ?? '',
            ))
        .toList();
  }

  void saveProfileInfo(ProfileInfo profileInfo) {
    _myBox.put('profileInfo', profileInfo.toMap());
  }

  ProfileInfo loadProfileInfo() {
    var profileMap = _myBox.get('profileInfo');
    if (profileMap != null) {
      return ProfileInfo.fromMap(profileMap.cast<String, dynamic>());
    } else {
      return ProfileInfo(
        name: '',
        major: '',
        dateOfBirth: '',
        email: '',
        profileImagePath: '',
        fullName: '',
        hobby: '',
        socialMedia: '',
      );
    }
  }
}
