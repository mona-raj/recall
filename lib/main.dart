import 'package:flutter/material.dart';
import 'package:recall/screens/home_screen.dart';
import 'package:recall/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Don't block first frame; failures here shouldn't prevent home screen render.
  NotificationService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
} 
