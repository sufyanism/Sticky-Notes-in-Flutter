import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes_app/controllers/note_controller.dart';
import 'package:sticky_notes_app/models/note_model.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel note;
  const EditNoteScreen({super.key, required this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController subjectController;
  late TextEditingController descController;
  late DateTime selectedDate;

  final NoteController controller = Get.find();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.title);
    subjectController = TextEditingController(text: widget.note.subject);
    descController = TextEditingController(text: widget.note.description);
    selectedDate = widget.note.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: "Subject")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Deadline: ${selectedDate.toLocal().toString().split(' ')[0]}"),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.updateNote(
                    NoteModel(
                      id: widget.note.id,
                      title: titleController.text,
                      subject: subjectController.text,
                      description: descController.text,
                      deadline: selectedDate,
                      isCompleted: widget.note.isCompleted,
                    ),
                  );
                  Get.back();
                },
                child: const Text("Update Note"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
