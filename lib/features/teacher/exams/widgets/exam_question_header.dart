import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';

class ExamQuestionHeader extends StatelessWidget {
  final QuizModel quiz;
  final VoidCallback onImport;

  const ExamQuestionHeader({
    super.key,
    required this.quiz,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Câu hỏi (${quiz.questions.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton.icon(
          onPressed: onImport,
          icon: const Icon(Icons.download_outlined),
          label: const Text('Nhập từ NHCH'),
        ),
      ],
    );
  }
}
