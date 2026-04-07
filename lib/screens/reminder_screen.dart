import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  TimeOfDay? selectedTime;

  Future<void> pickTime(BuildContext context, TimeOfDay? initialTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() async {
        selectedTime = pickedTime;
      });
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
                    child: Text("Pick time"),
                  ),
                  Text("Selected time: ${selectedTime?.format(context)}"),
                ],
              ),
              ElevatedButton(
                onPressed: () => {print("Saved reminder")},
                child: Text("Save Reminder"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
