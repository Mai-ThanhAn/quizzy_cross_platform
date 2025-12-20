import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/question_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/widgets/question_bank_card.dart';

class QuestionListScreen extends StatefulWidget {
  static const routeName = '/questions_in_bank';
  final QuestionBankModel bank;

  const QuestionListScreen({super.key, required this.bank});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuestionListViewModel>().fetchQuestions(widget.bank.id);
    });
  }

  void _confirmDelete(String questionId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa câu hỏi?'),
        content: const Text('Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<QuestionListViewModel>().deleteQuestion(questionId);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Helper widget cho trạng thái trống
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
              Icons.post_add_rounded,
              size: 64,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Bộ đề này đang trống',
            style: TextStyle(
              fontSize: 18, 
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bấm nút "Thêm câu hỏi" để bắt đầu',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestionListViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black87,
        title: Column(
          children: [
            Text(
              widget.bank.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${vm.questions.length} câu hỏi',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Nút refresh nhỏ
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
              onPressed: () => context.read<QuestionListViewModel>().fetchQuestions(widget.bank.id),
            ),
          )
        ],
      ),
      body: Builder(
        builder: (context) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          }

          if (vm.questions.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: vm.questions.length,
            itemBuilder: (context, index) {
              final question = vm.questions[index];
              
              // Bọc QuestionBankCard trong Container đổ bóng để đồng bộ style
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: QuestionBankCard(
                    question: question,
                    onDelete: () => _confirmDelete(question.id),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        "/edit_question",
                        arguments: question,
                      );
                      if (mounted) {
                        context.read<QuestionListViewModel>().fetchQuestions(
                          widget.bank.id,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              '/create_question',
              arguments: widget.bank.id,
            );
            if (mounted) {
              vm.fetchQuestions(widget.bank.id);
            }
          },
          label: const Text('Thêm câu hỏi', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: const Icon(Icons.add_rounded),
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}