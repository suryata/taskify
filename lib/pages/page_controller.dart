import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'todo_list.dart';
import 'add_page.dart';
import 'profile.dart';
import 'past_task.dart';
import 'calendar_page.dart';

class PageControllers extends StatefulWidget {
  final int initialPage;
  const PageControllers({super.key, this.initialPage = 0});

  @override
  State<PageControllers> createState() => _PageControllersState();
}

class _PageControllersState extends State<PageControllers> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  late int index;
  final screens = [
    const TodoPage(),
    const PastTaskPage(),
    const AddPage(),
    const CalendarPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home_rounded, color: Colors.white),
      const Icon(Icons.history, color: Colors.white),
      const Icon(Icons.add_circle_outline_outlined, color: Colors.white),
      const Icon(Icons.calendar_month_outlined, color: Colors.white),
      const Icon(Icons.account_circle_outlined, color: Colors.white),
    ];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        items: items,
        index: index,
        height: 65,
        backgroundColor: const Color.fromARGB(255, 196, 236, 255),
        buttonBackgroundColor: const Color.fromARGB(255, 16, 44, 121),
        color: Color.fromARGB(255, 16, 104, 156),
        onTap: (tappedIndex) {
          setState(() {
            index = tappedIndex;
          });
        },
      ),
    );
  }
}
