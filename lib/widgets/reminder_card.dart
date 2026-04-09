import 'package:flutter/material.dart';
import 'dart:io';

class ReminderCard extends StatelessWidget {
  final String? imgPath;
  final String title;
  final String time;
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
                children: [_CardText(title), _CardText(time)],
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

class _CardText extends StatelessWidget {
  final String text;

  _CardText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight(600)),
    );
  }
}
