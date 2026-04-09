class Reminder {
  Reminder({
    required this.title,
    required this.time,
    required this.imagePath,
    this.isComplete = false,
  });

  final String title;
  final String time;
  final String imagePath;
  bool isComplete;
}
