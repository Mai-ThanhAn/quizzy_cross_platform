import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';

class QuestionItemCard extends StatelessWidget {
  final int index;
  final QuizQuestion question;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const QuestionItemCard({
    super.key,
    required this.index,
    required this.question,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Câu ${index + 1} (${question.score} điểm)',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              question.content,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Divider(height: 24),
            ...question.options.map((opt) {
              final isCorrect = opt['isCorrect'] == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.circle_outlined,
                      color: isCorrect ? Colors.green : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        opt['content'] ?? '',
                        style: TextStyle(
                          color: isCorrect ? Colors.green[700] : Colors.black87,
                          fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}