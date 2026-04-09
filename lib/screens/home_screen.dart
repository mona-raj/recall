import 'package:flutter/material.dart';
import 'package:recall/models/reminder.dart';
import 'package:recall/screens/reminder_screen.dart';
import 'package:recall/widgets/reminder_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Reminder> reminders = [];

  Future<void> _addReminder() async {
    final newReminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReminderScreen()),
    );

    if (newReminder != null) {
      setState(() {
        reminders.add(newReminder);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recall Memory Assistant"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: reminders.length,
        itemBuilder: (context, index) => Dismissible(
          key: Key(reminders[index].title),
          direction: DismissDirection.endToStart, // right to left
          background: Container(
            color: Colors.red,
            child: Icon(Icons.delete_outline),
          ),
          onDismissed: (direction) {
            final removedReminder = reminders[index];
            final removedIndex = index;

            setState(() {
              reminders.removeAt(index);
            });

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
                  },
                ),
              ),
            );
          },
          child: GestureDetector(
            onTap: () {
              setState(() {
                reminders[index].isComplete = !reminders[index].isComplete;
              });
            },
            child: ReminderCard(
              reminders[index].imagePath,
              reminders[index].title,
              reminders[index].time,
              reminders[index].isComplete
            ),
          ),
        ),
      ),
    );
  }
}
