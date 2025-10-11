class NoteModel{
  String id;
  String title;
  String subject;
  String description;
  DateTime deadline;
  bool isCompleted;

  NoteModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
});
}