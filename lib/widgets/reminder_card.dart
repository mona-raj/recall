import 'package:flutter/material.dart';
import 'dart:io';

class ReminderCard extends StatelessWidget {
  final String? imgPath;
  final String title;
  final TimeOfDay time;
  final bool isComplete;

  const ReminderCard(
    this.imgPath,
    this.title,
    this.time,
    this.isComplete, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isComplete ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                colorScheme.primary,
                colorScheme.primaryContainer,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CardImage(imgPath),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: colorScheme.onPrimary),
                        const SizedBox(width: 10),
                        Text(
                          time.format(context),
                          style: TextStyle(
                            color: colorScheme.onPrimary.withValues(alpha: 0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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

  const _CardImage(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: imgPath == null
          ? const Center(
              child: Icon(Icons.photo, size: 34, color: Colors.white70),
            )
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
