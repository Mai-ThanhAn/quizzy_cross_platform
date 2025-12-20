import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/exam_detail_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/exam_info_section.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/exam_question_header.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/empty_question_view.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/question_item_card.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/widgets/import_questions_sheet.dart';

class ExamDetailScreen extends StatefulWidget {
  final String quizId;

  const ExamDetailScreen({super.key, required this.quizId});

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamDetailViewModel>().fetchQuizDetail(widget.quizId);
    });
  }

  Future<void> _navigateToEdit(QuizModel quiz) async {
    await Navigator.pushNamed(
      context,
      '/edit_exam',
      arguments: quiz,
    );

    if (mounted) {
      context.read<ExamDetailViewModel>().fetchQuizDetail(widget.quizId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExamDetailViewModel>();
    final quiz = vm.quiz;

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quiz == null || vm.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi Tiết Bài Kiểm Tra')),
        body: Center(child: Text(vm.errorMessage ?? 'Không tìm thấy bài thi')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Bài Kiểm Tra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Kết quả',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/quiz_results',
                arguments: quiz,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Cấu hình',
            onPressed: () => _navigateToEdit(quiz),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExamInfoSection(quiz: quiz),

          const SizedBox(height: 24),

          ExamQuestionHeader(
            quiz: quiz,
            onImport: () {
              if (quiz.status == 'published') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cần chuyển về Nháp để chỉnh sửa đề thi'),
                  ),
                );
                return;
              }

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) =>
                    ImportQuestionsSheet(quizId: widget.quizId),
              );
            },
          ),

          const SizedBox(height: 12),

          quiz.questions.isEmpty
              ? const EmptyQuestionView()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quiz.questions.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return QuestionItemCard(
                      index: index,
                      question: quiz.questions[index],
                      onEdit: () {},
                      onDelete: () {},
                    );
                  },
                ),
        ],
      ),
    );
  }
}
