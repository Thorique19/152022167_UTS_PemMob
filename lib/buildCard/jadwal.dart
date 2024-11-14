import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:riqapp/custom_colors.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};

  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Add New Schedule',
          style: GoogleFonts.bitter(
            color: CustomColors.primaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                labelStyle:
                    GoogleFonts.bitter(color: CustomColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time (HH:mm)',
                labelStyle:
                    GoogleFonts.bitter(color: CustomColors.primaryColor),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CustomColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eventController.clear();
              _timeController.clear();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.bitter(color: CustomColors.primaryColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_eventController.text.isEmpty) return;

              final event = Event(
                title: _eventController.text,
                time: _timeController.text,
              );

              setState(() {
                final day = DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                );
                if (_events[day] == null) _events[day] = [];
                _events[day]!.add(event);
              });

              Navigator.pop(context);
              _eventController.clear();
              _timeController.clear();
            },
            child: Text(
              'Save',
              style: GoogleFonts.bitter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: Text(
          'Schedule',
          style: GoogleFonts.bitter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              markersMaxCount: 1,
              selectedDecoration: BoxDecoration(
                color: CustomColors.primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: CustomColors.primaryLight,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: GoogleFonts.bitter(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _getEventsForDay(_selectedDay!).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay!)[index];
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      event.title,
                      style: GoogleFonts.bitter(
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primaryDark,
                      ),
                    ),
                    subtitle: Text(
                      event.time,
                      style: GoogleFonts.bitter(
                        color: CustomColors.primaryLight,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: CustomColors.errorColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _events[_selectedDay!]?.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primaryColor,
        onPressed: _addEvent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class Event {
  final String title;
  final String time;

  Event({required this.title, required this.time});
}
