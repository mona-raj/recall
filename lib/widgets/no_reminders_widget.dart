import 'package:flutter/material.dart';

class NoRemindersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Icon(Icons.notifications_none),
          Text("No reminders yet"),
          Text("Tap + to create a reminder"),
        ],
      ),
    );
  }
}
