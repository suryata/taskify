import 'package:flutter/material.dart';
import 'package:taskify/pages/edit_page.dart';
import 'package:taskify/pages/page_controller.dart';
import '../data/database.dart';
import '../util/tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
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
            'Task Management',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PageControllers(initialPage: 2)));
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Add Task', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1580C2),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 22.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 15),
                            Image.asset('assets/images/batik.png', width: 70),
                            SizedBox(width: 30),
                            Expanded(
                              child: Text(
                                "Make it happen, \n${_formatName(db.loadProfileInfo().name)}",
                                style: TextStyle(
                                  color: Color(0xFF1580C2),
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          if (!tasks[index].isCompleted) {
                            // Hanya tampilkan jika belum selesai
                            return ToDoTile(
                              taskName: tasks[index].title,
                              taskCompleted: tasks[index].isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  tasks[index].isCompleted = value!;
                                  db.updateTask(index, tasks[index]);
                                });
                              },
                              editFunction: (context) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPage(
                                      taskToEdit: tasks[index],
                                      taskIndex: index,
                                    ),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                              deleteFunction: (context) {
                                setState(() {
                                  db.deleteTask(index);
                                });
                              },
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
