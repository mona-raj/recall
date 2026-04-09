import 'package:flutter/material.dart';
import 'package:recall/models/reminder.dart';

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
    String imagePath =
        'https://static.thenounproject.com/png/default-image-icon-4595376-512.png';

    if (title.isEmpty) {
      showMessage("Please enter a reminder title");
    } else if (selectedTime == null) {
      showMessage("Please select a time");
    } else {
      String time = selectedTime!.format(context);
      Reminder newReminder = Reminder(title: title, time: time, imagePath: imagePath);
      Navigator.pop(context, newReminder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Reminder"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Enter Reminder name'),
              ),
              ElevatedButton(
                onPressed: () => {print("Image picked")},
                child: Text("Add photo"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => pickTime(context, selectedTime),
                    child: Text("Select time"),
                  ),
                  Text("Selected time: ${selectedTime?.format(context)}"),
                ],
              ),
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
