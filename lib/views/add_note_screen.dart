import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../services/notification_service.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    final NoteController controller = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: subjectController, decoration: const InputDecoration(labelText: "Subject")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 10),

            // Date Picker
            Row(
              children: [
                Text("Deadline: ${selectedDate.toLocal()}".split(' ')[0]),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) selectedDate = picked;
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) selectedTime = pickedTime;
              },
              child: const Text("Pick Time"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final scheduledDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                controller.addNote(
                  titleController.text,
                  subjectController.text,
                  descController.text,
                  selectedDate,
                );

                await NotificationService.scheduleNotification(
                  id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                  title: titleController.text,
                  body: "Don't forget your note: ${subjectController.text}",
                  scheduledDate: scheduledDateTime,
                );

                Get.back();
              },
              child: const Text("Save Note & Schedule Reminder"),
            ),

            ElevatedButton(onPressed: () async
            {
              await NotificationService.showInstantNotification(
                  id: 999,
                  title: 'Test Notification',
                  body: 'This is a Notification from emulator'
              );
              Get.back();
            }, child: Text("Text Notification"),
             )
          ],
        ),
      ),
    );
  }
}
