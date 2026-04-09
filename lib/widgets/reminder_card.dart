import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String time;
  final bool isComplete;

  ReminderCard(this.imgUrl, this.title, this.time, this.isComplete);

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
            spacing: 32,
            children: [
              _CardImage(imgUrl),
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
  final String imgUrl;

  _CardImage(this.imgUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imgUrl), // Your ImageProvider
          fit: BoxFit.cover, // Ensures the image fills the container
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
