import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/student_class_detail_viewmodel.dart';

class StudentClassDetailScreen extends StatefulWidget {
  static const routeName = '/student_class_detail';
  final ClassModel classModel;

  const StudentClassDetailScreen({super.key, required this.classModel});

  @override
  State<StudentClassDetailScreen> createState() =>
      _StudentClassDetailScreenState();
}

class _StudentClassDetailScreenState extends State<StudentClassDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<StudentClassDetailViewModel>()
          .fetchQuizzes(widget.classModel.id);
    });
  }

  // Helper: Widget hiển thị khi danh sách trống
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Chưa có bài kiểm tra nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng quay lại sau',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StudentClassDetailViewModel>();
    final dateFormat = DateFormat.MMMMEEEEd('vi_VN');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: Text(
          widget.classModel.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFF8F9FA),
        foregroundColor: Colors.black87,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : vm.quizzes.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  itemCount: vm.quizzes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final item = vm.quizzes[index];
                    final quiz = item.quiz;
                    final result = item.result;
                    final isDone = item.isCompleted;

                    final now = DateTime.now();
                    final isOpen = now.isAfter(quiz.settings.startTime) &&
                        now.isBefore(quiz.settings.endTime);

                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER: TITLE + SCORE BADGE
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  quiz.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isDone)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    '${result!.score}/${result.maxScore}',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// METADATA (TIME & DURATION)
                          Row(
                            children: [
                              _InfoItem(
                                icon: Icons.timer_outlined,
                                text: '${quiz.settings.durationMinutes} phút',
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _InfoItem(
                                  icon: Icons.event_busy_outlined,
                                  text: dateFormat.format(quiz.settings.endTime),
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// ACTION BUTTON
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isOpen && !isDone
                                  ? [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: isDone
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Bạn đã nộp bài lúc: ${dateFormat.format(result!.submittedAt)}',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  : isOpen
                                      ? () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              title: const Text('Bắt đầu làm bài', style: TextStyle(fontWeight: FontWeight.bold)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Bài thi: ${quiz.title}'),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'Thời gian: ${quiz.settings.durationMinutes} phút',
                                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      children: const [
                                                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            'Không thể tạm dừng khi đã bắt đầu.',
                                                            style: TextStyle(color: Colors.orange, fontSize: 13),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(ctx),
                                                  child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/do_quiz',
                                                      arguments: quiz,
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blueAccent,
                                                    foregroundColor: Colors.white,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  ),
                                                  child: const Text('Bắt đầu ngay'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: isDone
                                    ? Colors.green.withOpacity(0.1) // Màu nền khi xong
                                    : isOpen
                                        ? Colors.blueAccent // Màu nền khi mở
                                        : Colors.grey[200], // Màu nền khi đóng
                                foregroundColor: isDone
                                    ? Colors.green
                                    : isOpen
                                        ? Colors.white
                                        : Colors.grey[500],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                isDone
                                    ? 'Đã Hoàn Thành' // Thay đổi text chút cho hợp ngữ cảnh nút bấm
                                    : isOpen
                                        ? 'Làm Bài Ngay'
                                        : 'Đã Kết Thúc',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}