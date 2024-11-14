import 'dart:convert'; // Import to convert data to JSON format
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:riqapp/custom_colors.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class Note {
  String title;
  String content;
  DateTime dueDate;
  bool isDone;
  DateTime createdAt;

  Note({
    required this.title,
    required this.content,
    required this.dueDate,
    this.isDone = false,
    required this.createdAt,
  });

  // Convert a Note to a Map for storing in SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'dueDate': dueDate.toIso8601String(),
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map into a Note object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      content: map['content'],
      dueDate: DateTime.parse(map['dueDate']),
      isDone: map['isDone'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load saved notes from SharedPreferences
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List<dynamic> notesList = jsonDecode(notesJson);
      setState(() {
        _notes.addAll(notesList.map((note) => Note.fromMap(note)).toList());
      });
    }
  }

  // Save notes to SharedPreferences
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> notesMap =
        _notes.map((note) => note.toMap()).toList();
    await prefs.setString('notes', jsonEncode(notesMap));
  }

  void _addNote() {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        _selectedDate != null) {
      setState(() {
        _notes.add(Note(
          title: _titleController.text,
          content: _contentController.text,
          dueDate: _selectedDate!,
          createdAt: DateTime.now(),
        ));
        _titleController.clear();
        _contentController.clear();
        _selectedDate = null;
      });
      _saveNotes(); // Save the updated list of notes
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColors.primaryColor,
              onPrimary: CustomColors.backgroundColor,
              surface: CustomColors.backgroundColor,
              onSurface: CustomColors.primaryDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.backgroundColor,
        title: Text(
          'My Tasks',
          style: GoogleFonts.bitter(
            color: CustomColors.primaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: CustomColors.primaryLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: GoogleFonts.bitter(
                      color: CustomColors.primaryLight,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Dismissible(
                  key: Key(note.createdAt.toString()),
                  background: Container(
                    color: CustomColors.errorColor,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _notes.removeAt(index);
                    });
                    _saveNotes(); // Save the updated list after deletion
                  },
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          note.isDone = !note.isDone;
                        });
                        _saveNotes(); // Save the updated list after status change
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    note.title,
                                    style: GoogleFonts.bitter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      decoration: note.isDone
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: note.isDone
                                          ? CustomColors.primaryLight
                                          : CustomColors.primaryDark,
                                    ),
                                  ),
                                ),
                                Icon(
                                  note.isDone
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: note.isDone
                                      ? CustomColors.primaryLight
                                      : CustomColors.primaryColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              note.content,
                              style: GoogleFonts.bitter(
                                fontSize: 16,
                                color: CustomColors.primaryColor,
                                decoration: note.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: CustomColors.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(note.dueDate),
                                  style: GoogleFonts.bitter(
                                    fontSize: 14,
                                    color: CustomColors.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Task',
                    style: GoogleFonts.bitter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle:
                          GoogleFonts.bitter(color: CustomColors.primaryLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: CustomColors.primaryColor),
                      ),
                    ),
                    style: GoogleFonts.bitter(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle:
                          GoogleFonts.bitter(color: CustomColors.primaryLight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: CustomColors.primaryColor),
                      ),
                    ),
                    style: GoogleFonts.bitter(),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomColors.primaryLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: CustomColors.primaryLight,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedDate == null
                                ? 'Select Due Date'
                                : DateFormat('MMM dd, yyyy')
                                    .format(_selectedDate!),
                            style: GoogleFonts.bitter(
                              color: CustomColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Add Task',
                        style: GoogleFonts.bitter(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
