import 'package:flutter/material.dart';
import 'package:taskify/util/tile.dart';
import '../data/database.dart';

class PastTaskPage extends StatefulWidget {
  const PastTaskPage({Key? key}) : super(key: key);

  @override
  State<PastTaskPage> createState() => _PastTaskPageState();
}

class _PastTaskPageState extends State<PastTaskPage> {
  late ToDoDataBase db;

  @override
  void initState() {
    super.initState();
    db = ToDoDataBase();
  }

  String _formatName(String name) {
    String formattedName = name.split(' ')[0];
    if (formattedName.length > 8) {
      formattedName = formattedName.substring(0, 8);
    }
    return formattedName[0].toUpperCase() + formattedName.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = db.getTasks();

    return Scaffold(
      backgroundColor: Color(0xFFEFFEFF),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            'Completed Tasks',
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
      // Floating action button dan lokasinya bisa disesuaikan atau dihilangkan
      // sesuai dengan kebutuhan halaman PastTaskPage.
      body: Container(
        color: Color.fromARGB(255, 16, 104, 156),
        child: Column(
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
                  padding: EdgeInsets.fromLTRB(16.0, 25.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header bisa disesuaikan atau dihilangkan sesuai dengan kebutuhan
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          // Hanya tampilkan jika task telah selesai
                          if (tasks[index].isCompleted) {
                            return ToDoTile(
                              taskName: tasks[index].title,
                              taskCompleted: tasks[index].isCompleted,
                              onChanged: (value) {},
                              editFunction: (context) {},
                              deleteFunction: (context) {},
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
