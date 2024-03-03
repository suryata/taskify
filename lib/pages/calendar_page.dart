import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../data/database.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late ToDoDataBase db;
  late Map<DateTime, List<Task>> _events;
  late List<Task> _selectedTasks;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeDbAndLoadTasks();
  }

  Future<void> _initializeDbAndLoadTasks() async {
    db = ToDoDataBase();
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = db.getTasks().where((task) => !task.isCompleted).toList();

    final Map<DateTime, List<Task>> tempEvents = {};
    for (var task in tasks) {
      final endDate =
          DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
      if (!tempEvents.containsKey(endDate)) {
        tempEvents[endDate] = [];
      }
      tempEvents[endDate]?.add(task);
    }

    setState(() {
      _events = tempEvents;
      _selectedTasks = _events[_selectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
            eventLoader: (day) {
              return _events[DateTime(day.year, day.month, day.day)] ?? [];
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedTasks = _events[selectedDay] ?? [];
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_selectedTasks[index].title),
                  subtitle: Text(
                      'End Date: ${_selectedTasks[index].endDate.toIso8601String()}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
