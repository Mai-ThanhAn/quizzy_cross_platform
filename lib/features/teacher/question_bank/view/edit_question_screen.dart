import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/edit_question_viewmodel.dart';

class EditQuestionScreen extends StatefulWidget {
  static const routeName = '/edit_question';
  final QuestionModel question;

  const EditQuestionScreen({super.key, required this.question});

  @override
  State<EditQuestionScreen> createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.question.content);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditQuestionViewModel>().initialize(widget.question);
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() async {
    final vm = context.read<EditQuestionViewModel>();
    final success = await vm.updateQuestion(content: _contentController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Cập nhật thành công' : vm.errorMessage ?? 'Lỗi'),
        backgroundColor: success ? null : Colors.red,
      ),
    );

    if (success) Navigator.pop(context);
  }

  // ---------- UI HELPERS ----------

  Widget _card({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditQuestionViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa câu hỏi',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: vm.isLoading ? null : _submit,
            icon: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== NỘI DUNG =====
            _sectionTitle('NỘI DUNG'),
            const SizedBox(height: 8),
            _card(
              child: TextField(
                controller: _contentController,
                maxLines: 4,
                decoration: _inputDecor('Nhập nội dung câu hỏi...'),
              ),
            ),

            const SizedBox(height: 24),

            // ===== THIẾT LẬP =====
            _sectionTitle('THIẾT LẬP'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _card(
                    child: DropdownButtonFormField<String>(
                      value: vm.type,
                      decoration: _inputDecor('Loại câu hỏi'),
                      icon: const Icon(Icons.expand_more),
                      items: const [
                        DropdownMenuItem(
                          value: 'multiple_choice',
                          child: Text('Nhiều đáp án'),
                        ),
                        DropdownMenuItem(
                          value: 'single_choice',
                          child: Text('Một đáp án'),
                        ),
                      ],
                      onChanged: vm.setType,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _card(
                    child: DropdownButtonFormField<String>(
                      value: vm.difficulty,
                      decoration: _inputDecor('Độ khó'),
                      icon: const Icon(Icons.expand_more),
                      items: const [
                        DropdownMenuItem(value: 'easy', child: Text('Dễ')),
                        DropdownMenuItem(value: 'medium', child: Text('Trung bình')),
                        DropdownMenuItem(value: 'hard', child: Text('Khó')),
                      ],
                      onChanged: vm.setDifficulty,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ===== ĐÁP ÁN =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('ĐÁP ÁN'),
                TextButton.icon(
                  onPressed: vm.addOption,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...List.generate(vm.options.length, (index) {
              final option = vm.options[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Checkbox(
                        value: option.isCorrect,
                        shape: vm.type == 'single_choice'
                            ? const CircleBorder()
                            : null,
                        activeColor: Colors.green,
                        onChanged: (_) => vm.toggleOptionCorrect(index),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: option.text,
                        decoration: InputDecoration(
                          hintText: 'Đáp án ${index + 1}',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (v) => vm.updateOptionText(index, v),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => vm.removeOption(index),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[500],
        letterSpacing: 1.2,
      ),
    );
  }
}
