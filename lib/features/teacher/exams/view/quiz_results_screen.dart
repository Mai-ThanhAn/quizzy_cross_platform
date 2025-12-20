import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/core/constants/colors.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/quiz_results_viewmodel.dart';
import '../widgets/quiz_results_header.dart';
import '../widgets/student_result_tile.dart';

class QuizResultsScreen extends StatefulWidget {
  final QuizModel quiz;

  const QuizResultsScreen({super.key, required this.quiz});

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizResultsViewModel>().fetchResults(widget.quiz.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizResultsViewModel>();

    return Scaffold(
      backgroundColor: AppColors.color1,
      appBar: AppBar(
        backgroundColor: AppColors.color1,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kết Quả Bài Kiểm Tra',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.color2,
              ),
            ),
            Text(
              widget.quiz.title,
              style: const TextStyle(fontSize: 12, color: AppColors.color3),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          QuizResultsHeader(viewModel: vm),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.items.isEmpty
                ? const Center(
                    child: Text(
                      'Chưa có sinh viên nào nộp bài',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return StudentResultTile(item: vm.items[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
