import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_notes_app/models/note_model.dart';
import 'package:uuid/uuid.dart';

class NoteController extends GetxController {
  var notes = <NoteModel>[].obs;
  List<NoteModel> allNotes = [];
  bool showPendingOnly = false;

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> noteList =
    allNotes.map((note) => jsonEncode(_noteToJson(note))).toList();
    await prefs.setStringList('notes', noteList);
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final noteList = prefs.getStringList('notes') ?? [];
    allNotes = noteList.map((e) => _noteFromJson(jsonDecode(e))).toList();
    _applyFilter();
  }

  Map<String, dynamic> _noteToJson(NoteModel note) => {
    'id': note.id,
    'title': note.title,
    'subject': note.subject,
    'description': note.description,
    'deadline': note.deadline.toIso8601String(),
    'isCompleted': note.isCompleted,
  };

  NoteModel _noteFromJson(Map<String, dynamic> json) => NoteModel(
    id: json['id'],
    title: json['title'],
    subject: json['subject'],
    description: json['description'],
    deadline: DateTime.parse(json['deadline']),
    isCompleted: json['isCompleted'] ?? false,
  );

  Future<void> addNote(
      String title, String subject, String desc, DateTime deadline) async {
    final newNote = NoteModel(
      id: const Uuid().v4(),
      title: title,
      subject: subject,
      description: desc,
      deadline: deadline,
    );
    allNotes.add(newNote);
    _applyFilter();
    await saveNotes();
  }

  Future<void> deleteNote(String id) async {
    allNotes.removeWhere((note) => note.id == id);
    _applyFilter();
    await saveNotes();
  }

  Future<void> updateNote(NoteModel updatedNote) async {
    var index = allNotes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      allNotes[index] = updatedNote;
      await saveNotes();
      _applyFilter();
    }
  }

  Future<void> toggleComplete(String id) async {
    final index = allNotes.indexWhere((n) => n.id == id);
    if (index != -1) {
      allNotes[index] =
          allNotes[index].copyWith(isCompleted: !allNotes[index].isCompleted);
      await saveNotes();
      _applyFilter();
    }
  }

  void filterCompleted(bool showCompleted) {
    showPendingOnly = !showCompleted;
    _applyFilter();
  }

  void sortByDeadline() {
    allNotes.sort((a, b) => a.deadline.compareTo(b.deadline));
    _applyFilter();
  }

  void _applyFilter() {
    notes.value = showPendingOnly
        ? allNotes.where((n) => !n.isCompleted).toList()
        : List.from(allNotes);
    notes.refresh();
  }
}

extension NoteCopy on NoteModel {
  NoteModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
