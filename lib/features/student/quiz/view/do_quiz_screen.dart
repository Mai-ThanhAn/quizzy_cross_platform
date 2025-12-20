import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/do_quiz_viewmodel.dart';

class DoQuizScreen extends StatefulWidget {
  static const routeName = '/do_quiz';
  final QuizModel quiz;

  const DoQuizScreen({super.key, required this.quiz});

  @override
  State<DoQuizScreen> createState() => _DoQuizScreenState();
}

class _DoQuizScreenState extends State<DoQuizScreen> {
  @override
  void initState() {
    super.initState();
    // Khởi tạo bài thi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoQuizViewModel>().init(widget.quiz);
    });
  }

  void _confirmSubmit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nộp bài?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc chắn muốn nộp bài không?\nHành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kiểm tra lại', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<DoQuizViewModel>().submitQuiz();
              if (mounted) {
                Navigator.pop(context); // Quay về màn hình chi tiết lớp
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã nộp bài thành công!'), backgroundColor: Colors.green),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Nộp bài ngay'),
          ),
        ],
      ),
    );
  }

  // Helper Widget: Card câu hỏi
  Widget _buildQuestionCard(int index, dynamic question, DoQuizViewModel vm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          // Header câu hỏi
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Q${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.content,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Điểm: ${question.score}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Danh sách đáp án
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: question.options.map<Widget>((opt) {
                final isSelected = vm.isOptionSelected(question.id, opt['id']);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent.withOpacity(0.05) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.grey.shade200,
                      width: isSelected ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: RadioListTile<String>(
                    title: Text(
                      opt['content'],
                      style: TextStyle(
                        color: isSelected ? Colors.blueAccent : Colors.black87,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    value: opt['id'],
                    groupValue: isSelected ? opt['id'] : null,
                    activeColor: Colors.blueAccent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onChanged: (_) {
                      vm.selectOption(question.id, opt['id'], true);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoQuizViewModel>();
    final quiz = widget.quiz;
    final isTimeRunningOut = vm.remainingSeconds < 60;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng nộp bài trước khi thoát!')),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
        appBar: AppBar(
          title: Text(
            quiz.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            // Timer Pill Widget
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: isTimeRunningOut ? Colors.redAccent.withOpacity(0.1) : Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isTimeRunningOut ? Colors.redAccent : Colors.blueAccent.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined, 
                    size: 18, 
                    color: isTimeRunningOut ? Colors.redAccent : Colors.blueAccent
                  ),
                  const SizedBox(width: 6),
                  Text(
                    vm.timeString,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isTimeRunningOut ? Colors.redAccent : Colors.blueAccent,
                      fontSize: 14,
                      fontFeatures: const [FontFeature.tabularFigures()], // Giữ số không bị nhảy
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: vm.isSubmitting
            ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
            : Column(
                children: [
                  // List Questions
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      itemCount: quiz.questions.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildQuestionCard(index, quiz.questions[index], vm);
                      },
                    ),
                  ),

                  // Bottom Submit Bar
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _confirmSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Nộp Bài Thi',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}