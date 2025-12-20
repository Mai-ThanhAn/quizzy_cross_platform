import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/exam_detail_viewmodel.dart';
import 'exam_status_badge.dart';

class ExamInfoSection extends StatelessWidget {
  final QuizModel quiz;

  const ExamInfoSection({super.key, required this.quiz});

  void _confirmChangeStatus(BuildContext context) {
    final vm = context.read<ExamDetailViewModel>();
    final isDraft = quiz.status == 'draft';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDraft
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                  ),
                  child: Icon(
                    isDraft ? Icons.public_outlined : Icons.edit_note_outlined,
                    color: isDraft
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  isDraft ? 'Xuất bản bài thi?' : 'Chuyển bài thi về Nháp?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isDraft
                      ? 'Sinh viên sẽ nhìn thấy và có thể làm bài ngay nếu đang trong thời gian cho phép.'
                      : 'Bài thi sẽ bị ẩn và sinh viên không thể truy cập nữa.',
                  style: const TextStyle(color: Colors.grey, height: 1.4),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey.shade700,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Hủy'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await vm.toggleQuizStatus();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  vm.errorMessage ??
                                      'Đã cập nhật trạng thái bài thi',
                                ),
                                backgroundColor: vm.errorMessage != null
                                    ? Colors.red
                                    : null,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isDraft
                              ? Colors.green.shade600
                              : Colors.orange.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          isDraft ? 'Xuất bản' : 'Về nháp',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm dd/MM/yyyy');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ExamStatusBadge(
                status: quiz.status,
                onTap: () => _confirmChangeStatus(context),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            quiz.description.isEmpty ? 'Không có mô tả' : quiz.description,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 16),

          Text(
            'Mở: ${dateFormat.format(quiz.settings.startTime)}',
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            'Đóng: ${dateFormat.format(quiz.settings.endTime)}',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
