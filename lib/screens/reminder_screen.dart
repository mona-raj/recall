import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recall/models/reminder.dart';
import 'package:recall/services/notification_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

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
      const int maxInt32 = 2147483647;
      final int generatedId = DateTime.now().millisecondsSinceEpoch.remainder(
        maxInt32,
      );
      Reminder newReminder = Reminder(
        notificationId: generatedId,
        title: title,
        time: selectedTime!,
        imagePath: imagePath,
      );

      NotificationService().scheduleNotification(
        id: generatedId,
        body: title,
        time: selectedTime!,
        imagePath: imagePath,
      );

      Navigator.pop(context, newReminder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Reminder"), centerTitle: true),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Reminder',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add title, photo, and time',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Reminder title',
                            prefixIcon: const Icon(Icons.edit_note_rounded),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.6),
                          ),
                          child: selectedImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 40,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No image selected',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(selectedImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.add_a_photo_outlined),
                            label: const Text('Add Photo'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.45),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  selectedTime == null
                                      ? 'No time selected'
                                      : 'Selected time: ${selectedTime!.format(context)}',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.tonalIcon(
                            onPressed: () => pickTime(context, selectedTime),
                            icon: const Icon(Icons.schedule_rounded),
                            label: const Text('Select Time'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: submitReminder,
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save Reminder'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
