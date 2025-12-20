import 'package:flutter/material.dart';

class EmptyQuestionView extends StatelessWidget {
  const EmptyQuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      alignment: Alignment.center,
      child: const Text(
        'Chưa có câu hỏi nào\nHãy thêm câu hỏi để bắt đầu',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
