// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, library_private_types_in_public_api, constant_identifier_names, unused_local_variable
import 'package:flutter/material.dart';
import 'package:taskify/pages/home_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              FadeTransition(
                opacity: _controller,
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: Image.asset('taskify/assets/images/landing.png',
                      fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 30),
              ScaleTransition(
                scale: _controller,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HomePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 58, 25, 0),
                    textStyle: const TextStyle(
                      fontSize: 17,
                      fontFamily: 'Georgia',
                      letterSpacing: 1.1,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 13),
                  ),
                  child: const Text(
                    "Begin your Journey",
                    style: TextStyle(color: Color.fromARGB(255, 255, 230, 198)),
                  ),
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // Adjusts the space at the bottom
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 239, 224, 209),
    );
  }
}
