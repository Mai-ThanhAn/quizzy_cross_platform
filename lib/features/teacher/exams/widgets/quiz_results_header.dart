import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/quiz_results_viewmodel.dart';
import 'result_stat_item.dart';

class QuizResultsHeader extends StatelessWidget {
  final QuizResultsViewModel viewModel;

  const QuizResultsHeader({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ResultStatItem(
            label: 'Đã nộp',
            value: '${viewModel.submittedCount}',
            icon: Icons.assignment_turned_in_outlined,
          ),
          ResultStatItem(
            label: 'Điểm TB',
            value: viewModel.averageScore.toStringAsFixed(1),
            icon: Icons.analytics_outlined,
          ),
        ],
      ),
    );
  }
}
