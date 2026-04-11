import 'package:flutter/material.dart';

class Reminder {
  Reminder({
    required this.notificationId,
    required this.title,
    required this.time,
    required this.imagePath,
    this.isComplete = false,
  });

  final int notificationId;
  final String title;
  final TimeOfDay time;
  final String? imagePath;
  bool isComplete;
}
