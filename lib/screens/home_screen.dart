import 'package:flutter/material.dart';
import 'package:recall/models/reminder.dart';
import 'package:recall/screens/reminder_screen.dart';
import 'package:recall/services/notification_service.dart';
import 'package:recall/widgets/no_reminders_widget.dart';
import 'package:recall/widgets/reminder_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> reminders = [];

  void _handleReminderDismiss(Reminder removedReminder) {
    final removedIndex = reminders.indexOf(removedReminder);
    if (removedIndex == -1) {
      return;
    }

    setState(() {
      reminders.removeAt(removedIndex);
    });

    NotificationService().cancelNotification(removedReminder.notificationId);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Reminder deleted"),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              reminders.insert(removedIndex, removedReminder);
            });

            NotificationService().scheduleNotification(
              id: removedReminder.notificationId,
              body: removedReminder.title,
              time: removedReminder.time,
            );
          },
        ),
      ),
    );
  }

  void _toggleReminderCompletion(Reminder currentReminder) {
    if (currentReminder.isComplete) {
      NotificationService().scheduleNotification(
        id: currentReminder.notificationId,
        body: currentReminder.title,
        time: currentReminder.time,
      );
    } else {
      NotificationService().cancelNotification(currentReminder.notificationId);
    }

    setState(() {
      currentReminder.isComplete = !currentReminder.isComplete;
    });
  }

  void _editReminder(Reminder currentReminder) {
    
  }

  Future<void> _addReminder() async {
    final newReminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReminderScreen(null)),
    );

    if (newReminder != null) {
      setState(() {
        reminders.add(newReminder);
      });
    }
  }

  String filter = "all";

  @override
  Widget build(BuildContext context) {
    List<Reminder> filteredReminders = reminders;
    if (filter == 'pending') {
      filteredReminders = reminders
          .where((reminder) => reminder.isComplete == false)
          .toList();
    } else if (filter == 'completed') {
      filteredReminders = reminders
          .where((reminder) => reminder.isComplete == true)
          .toList();
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),

      body: reminders.isEmpty
          ? NoRemindersWidget()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 12,
                    children: [
                      ChoiceChip(
                        label: Text("All"),
                        selected: filter == 'all',
                        onSelected: (bool selected) => setState(() {
                          filter = selected ? 'all' : 'all';
                        }),
                      ),
                      ChoiceChip(
                        label: Text("Pending"),
                        selected: filter == 'pending',
                        onSelected: (bool selected) => setState(() {
                          filter = selected ? 'pending' : 'all';
                        }),
                      ),
                      ChoiceChip(
                        label: Text("Completed"),
                        selected: filter == 'completed',
                        onSelected: (bool selected) => setState(() {
                          filter = selected ? 'completed' : 'all';
                        }),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: filteredReminders.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: Key(filteredReminders[index].title),
                      direction: DismissDirection.endToStart, // right to left
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete_outline),
                      ),
                      onDismissed: (direction) {
                        final removedReminder = filteredReminders[index];
                        _handleReminderDismiss(removedReminder);
                      },
                      child: GestureDetector(
                        onTap: () {
                          final currentReminder = filteredReminders[index];
                          _toggleReminderCompletion(currentReminder);
                        },

                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Text('Choose an option:'),
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                final removedReminder =
                                                    filteredReminders[index];
                                                _handleReminderDismiss(
                                                  removedReminder,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text("Delete"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final currentReminder =
                                                    filteredReminders[index];
                                                _editReminder(
                                                  currentReminder,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text("Edit"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                final currentReminder =
                                                    filteredReminders[index];
                                                _toggleReminderCompletion(
                                                  currentReminder,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text("Mark Complete"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },

                        child: ReminderCard(
                          filteredReminders[index].imagePath,
                          filteredReminders[index].title,
                          filteredReminders[index].time,
                          filteredReminders[index].isComplete,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
