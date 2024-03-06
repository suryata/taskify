import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final String taskDescription;
  final bool taskCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteFunction;
  final Function(BuildContext) editFunction;

  const ToDoTile({
    Key? key,
    required this.taskName,
    required this.taskDescription,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
  }) : super(key: key);

  @override
  _ToDoTileState createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: _buildSlidableTaskRow(),
    );
  }

  Widget _buildSlidableTaskRow() {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: widget.taskCompleted
            ? [
                // If the task is completed, only show the delete option
                SlidableAction(
                  onPressed: widget.deleteFunction,
                  icon: Icons.delete,
                  backgroundColor: const Color.fromARGB(255, 237, 148, 148),
                  borderRadius: BorderRadius.circular(12),
                ),
              ]
            : [
                // If the task is not completed, show both edit and delete options
                SlidableAction(
                  onPressed: widget.editFunction,
                  icon: Icons.edit,
                  backgroundColor: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                SlidableAction(
                  onPressed: widget.deleteFunction,
                  icon: Icons.delete,
                  backgroundColor: const Color.fromARGB(255, 237, 148, 148),
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
      ),
      child: _buildTaskRow(),
    );
  }

  Widget _buildTaskRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(186, 211, 246, 0.939),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: widget.taskCompleted,
            onChanged: widget.onChanged,
            shape: CircleBorder(),
            activeColor: Color.fromARGB(255, 31, 45, 91),
            checkColor: Colors.white,
          ),
          Expanded(
            child: Text(
              widget.taskName,
              style: TextStyle(
                fontSize: 20,
                decoration: widget.taskCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: widget.taskCompleted
                    ? const Color.fromARGB(255, 54, 54, 54)
                    : Colors.black,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline,
                color: Color.fromARGB(255, 31, 45, 91)),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.blueGrey[100],
                    title: Text("Task Description",
                        style: TextStyle(
                            color: Color.fromARGB(255, 16, 104, 156))),
                    content: Text(widget.taskDescription,
                        style: TextStyle(color: Colors.black54)),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Close",
                            style: TextStyle(
                                color: Color.fromARGB(255, 16, 104, 156))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
