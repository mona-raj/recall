import 'package:flutter/material.dart';
import 'dart:io';

class ReminderCard extends StatelessWidget {
  final String? imgPath;
  final String title;
  final TimeOfDay time;
  final bool isComplete;

  ReminderCard(this.imgPath, this.title, this.time, this.isComplete);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: isComplete ? 0.5 : 1,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color.fromARGB(255, 53, 191, 237),
                Color.fromARGB(255, 149, 184, 228),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 32,
            children: [
              _CardImage(imgPath),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight(600)),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10),
                      Text(
                        time.format(context),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          fontSize: 14,
                          fontWeight: FontWeight(400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final String? imgPath;

  _CardImage(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: imgPath == null
          ? Center(child: Icon(Icons.photo, size: 80, color: Colors.white70))
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: FileImage(File(imgPath!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
}
