import 'package:flutter/material.dart';
import 'package:recall/screens/reminder_screen.dart';
import 'package:recall/widgets/reminder_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Recall Memory Assistant"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReminderScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          ReminderCard(
            "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQmXNQqhpaZfcW1aLOBp1_18c36HlkvLKtPrreeyVr8gKjRrR2u",
            "Bring Umbrella",
            "9:00 am",
          ),
          ReminderCard(
            "https://images.ctfassets.net/sabbecbbwaz3/3vJo5zRIw20v31OnbfEiwo/6b5725df4aee79b06a843e77efa8347f/Vicks_AU_Cough_2in1_Syrup_front.jpg",
            "Take medicine",
            "10:00 am",
          ),
        ],
      ),
    );
  }
}
