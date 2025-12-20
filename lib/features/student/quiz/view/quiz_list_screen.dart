import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/quiz_list_viewmodel.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizListViewModel>().fetchAllQuizzes();
    });
  }

  // Helper cho trạng thái trống
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
              Icons.quiz_outlined,
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
            'Danh sách bài kiểm tra sẽ hiển thị tại đây',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizListViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: const Text(
          'Tất Cả Bài Kiểm Tra',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
              onPressed: () => vm.fetchAllQuizzes(),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }

          if (vm.errorMessage != null) {
            debugPrint(vm.errorMessage);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text('Lỗi: ${vm.errorMessage}', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          if (vm.quizzes.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchAllQuizzes(),
            color: Colors.blueAccent,
            backgroundColor: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: vm.quizzes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildQuizItem(vm.quizzes[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuizItem(QuizModel quiz) {
    final dateFormat = DateFormat.MMMMEEEEd('vi_VN');
    final now = DateTime.now();

    // Logic hiển thị trạng thái
    bool isOpen = now.isAfter(quiz.settings.startTime) && now.isBefore(quiz.settings.endTime);
    bool isClosed = now.isAfter(quiz.settings.endTime);

    Color statusColor = Colors.orange;
    String statusText = "Sắp tới";

    if (isOpen) {
      statusColor = Colors.green;
      statusText = "Đang mở";
    } else if (isClosed) {
      statusColor = Colors.grey;
      statusText = "Đã đóng";
    }

    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Xử lý sự kiện bấm vào bài thi
            if (isOpen) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vào làm bài... (Tuần sau)')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title + Status Badge
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),

                // Info Rows
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 18, color: Colors.blueAccent.withOpacity(0.7)),
                    const SizedBox(width: 8),
                    Text(
                      '${quiz.settings.durationMinutes} phút',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.calendar_today_rounded, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 6),
                    Text(
                      dateFormat.format(quiz.settings.endTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}