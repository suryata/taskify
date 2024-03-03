import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/database.dart';

class EditPage extends StatefulWidget {
  final Task taskToEdit;
  final int taskIndex;
  const EditPage({
    Key? key,
    required this.taskToEdit,
    required this.taskIndex,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final _formKey = GlobalKey<FormState>();
  late final _titleController =
      TextEditingController(text: widget.taskToEdit.title);
  late final _descriptionController =
      TextEditingController(text: widget.taskToEdit.description);
  late DateTime _startDate = widget.taskToEdit.startDate;
  late DateTime _endDate = widget.taskToEdit.endDate;
  late String _category = widget.taskToEdit.category;
  final ToDoDataBase _db = ToDoDataBase();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      // Create a new task object with the updated information
      final updatedTask = Task(
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _startDate,
        endDate: _endDate,
        category: _category,
      );
      // Call the database update function with the index and the new task object
      _db.updateTask(widget.taskIndex, updatedTask);

      // Navigate back to the previous page or show a success message
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            'Edit Task',
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
      body: Container(
        color: Color.fromARGB(255, 16, 104, 156),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, bottom: 8.0, top: 10.0),
                            child: Text(
                              'Title',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 16, 104, 156),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 2.0),
                            child: TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Start Date',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 16, 104, 156),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: TextEditingController(
                                            text: DateFormat('yyyy-MM-dd')
                                                .format(_startDate)),
                                        onTap: () => _selectDate(context, true),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'End Date',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 16, 104, 156),
                                          ),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: TextEditingController(
                                            text: DateFormat('yyyy-MM-dd')
                                                .format(_endDate)),
                                        onTap: () =>
                                            _selectDate(context, false),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0,
                                    bottom:
                                        8.0), // Adjust left padding for the 'Category' label
                                child: const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 16, 104, 156),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // This centers the buttons horizontally
                                children: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _category = 'Priority Task';
                                      });
                                    },
                                    child: Text(
                                      'Priority Task',
                                      style: TextStyle(
                                        color: _category == 'Priority Task'
                                            ? Colors.white
                                            : Color.fromARGB(255, 16, 104, 156),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _category ==
                                              'Priority Task'
                                          ? Color.fromARGB(255, 16, 104, 156)
                                          : Colors
                                              .white, // Selected and Unselected colors
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation: _category == 'Priority Task'
                                          ? 2.0
                                          : 0.0,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 42.0, vertical: 18.0),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 30.0), // Spacing between buttons
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _category = 'Daily Task';
                                      });
                                    },
                                    child: Text(
                                      'Daily Task',
                                      style: TextStyle(
                                        color: _category == 'Daily Task'
                                            ? Colors.white
                                            : Color.fromARGB(255, 16, 104, 156),
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _category == 'Daily Task'
                                          ? Color.fromARGB(255, 16, 104, 156)
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation:
                                          _category == 'Daily Task' ? 2.0 : 0.0,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 42.0, vertical: 18.0),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, bottom: 8.0, top: 2.0),
                                child: Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 16, 104, 156),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                child: TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    10.0), // Match the padding with the description field
                            child: ElevatedButton(
                              onPressed: _saveTask,
                              child: Text(
                                'Edit Task',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 16, 104, 156),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
