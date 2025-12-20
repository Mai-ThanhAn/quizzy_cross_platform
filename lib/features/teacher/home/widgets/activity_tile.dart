import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String title;
  final String time;
  final bool isQuiz;

  const ActivityTile({
    super.key,
    required this.title,
    required this.time,
    required this.isQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isQuiz ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isQuiz ? Icons.quiz_outlined : Icons.notifications_outlined,
          color: isQuiz ? Colors.blue : Colors.orange,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(time),
    );
  }
}