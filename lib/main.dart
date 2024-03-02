// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_local_variable
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskify/pages/landing.dart';

void main() async {
  // init the hive
  await Hive.initFlutter();

  // open a box
  var box = await Hive.openBox('mybox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 171, 248, 255),
      ),
    );
  }
}
