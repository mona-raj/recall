import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recall/models/reminder.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart';

class ReminderScreen extends StatefulWidget {
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TextEditingController titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  XFile? selectedImage;

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Choose an option"),
        content: Text(
          "Take a photo with your camera or choose from your gallery",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final XFile? image = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (!mounted) return;
              setState(() {
                selectedImage = image;
              });
              Navigator.pop(context);
            },
            child: Text("Camera"),
          ),
          TextButton(
            onPressed: () async {
              final XFile? image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (!mounted) return;
              setState(() {
                selectedImage = image;
              });
              Navigator.pop(context);
            },
            child: Text("Gallery"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedImage = null;
              });
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  TimeOfDay? selectedTime;

  Future<void> pickTime(BuildContext context, TimeOfDay? initialTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  void submitReminder() {
    String title = titleController.text.trim();
    String? imagePath = selectedImage?.path;

    if (title.isEmpty) {
      showMessage("Please enter a reminder title");
    } else if (selectedTime == null) {
      showMessage("Please select a time");
    } else {
      String time = selectedTime!.format(context);
      Reminder newReminder = Reminder(
        title: title,
        time: time,
        imagePath: imagePath,
      );
      Navigator.pop(context, newReminder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Reminder"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Enter Reminder name',
                        ),
                      ),
                      SizedBox(height: 8),
                      if (selectedImage != null)
                        Image.file(
                          File(selectedImage!.path),
                          height: 200,
                          width: 200,
                        ),
                      ElevatedButton(
                        onPressed: () => pickImage(),
                        child: Text("Add photo"),
                      ),
                      SizedBox(height: 8),
                      if (selectedTime != null)
                        Text(
                          textAlign: TextAlign.center,
                          "Selected time: ${selectedTime?.format(context)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ElevatedButton(
                        onPressed: () => pickTime(context, selectedTime),
                        child: Text("Select time"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: submitReminder,
                child: Text("Save Reminder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
