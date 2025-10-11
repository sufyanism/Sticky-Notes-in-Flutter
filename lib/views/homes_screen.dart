import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sticky_notes_app/controllers/note_controller.dart';
import 'add_note_screen.dart';
import 'edit_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final NoteController controller = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sticky Notes"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => controller.sortByDeadline(),
                  child: const Text("Sort by Deadline"),
                ),
                ElevatedButton(
                  onPressed: () => controller.filterCompleted(false),
                  child: const Text("Show Pending"),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              final notes = controller.notes;
              if (notes.isEmpty) {
                return const Center(child: Text("No notes available"));
              }
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(
                        decoration: note.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(note.deadline.toString()),
                    onTap: () => controller.toggleComplete(note.id),
                    onLongPress: () => Get.to(() => EditNoteScreen(note: note)), // 🔥 open edit on long press
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          note.isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: note.isCompleted ? Colors.green : null,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => controller.deleteNote(note.id),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddNoteScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
