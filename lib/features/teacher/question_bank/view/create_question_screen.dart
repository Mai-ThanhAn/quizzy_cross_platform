import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/create_question_viewmodel.dart';

class CreateQuestionScreen extends StatefulWidget {
  final String bankId;

  const CreateQuestionScreen({super.key, required this.bankId});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() async {
    final vm = context.read<CreateQuestionViewModel>();
    final success = await vm.createQuestion(
      bankId: widget.bankId,
      content: _contentController.text,
    );

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm câu hỏi thành công')),
      );
    } else if (mounted && vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(vm.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildShadowContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _minimalInputDecor(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateQuestionViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: const Text(
          'Soạn Thảo Câu Hỏi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          // Nút save phụ trên appbar (Icon)
          IconButton(
            onPressed: vm.isLoading ? null : _submit,
            icon: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check_rounded, color: Colors.blueAccent),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Section: Nội dung ---
            Text(
              "NỘI DUNG",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),
            
            _buildShadowContainer(
              child: TextField(
                controller: _contentController,
                maxLines: 4,
                style: const TextStyle(fontSize: 16),
                decoration: _minimalInputDecor('Nhập câu hỏi của bạn tại đây...'),
              ),
            ),
            
            const SizedBox(height: 24),

            // --- Section: Cấu hình ---
            Text(
              "THIẾT LẬP",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 1.2),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _buildShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonFormField<String>(
                        value: vm.type,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          labelText: 'Loại câu hỏi',
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: const [
                          DropdownMenuItem(
                              value: 'multiple_choice', child: Text('Nhiều đáp án')),
                          DropdownMenuItem(
                              value: 'single_choice', child: Text('Một đáp án')),
                        ],
                        onChanged: vm.setType,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildShadowContainer(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonFormField<String>(
                        value: vm.difficulty,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          labelText: 'Độ khó',
                        ),
                         icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: const [
                          DropdownMenuItem(value: 'easy', child: Text('Dễ')),
                          DropdownMenuItem(
                              value: 'medium', child: Text('Trung bình')),
                          DropdownMenuItem(value: 'hard', child: Text('Khó')),
                        ],
                        onChanged: vm.setDifficulty,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),

            // --- Section: Đáp án ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ĐÁP ÁN LỰA CHỌN",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                      letterSpacing: 1.2),
                ),
                TextButton.icon(
                  onPressed: vm.addOption,
                  icon: const Icon(Icons.add_circle_rounded, size: 18),
                  label: const Text('Thêm lựa chọn', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                  ),
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Checkbox custom container
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Tooltip(
                        message: 'Đánh dấu là đáp án đúng',
                        child: Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: option.isCorrect,
                            activeColor: Colors.green,
                            side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                            shape: vm.type == 'single_choice'
                                ? const CircleBorder()
                                : RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (_) => vm.toggleOptionCorrect(index),
                          ),
                        ),
                      ),
                    ),

                    // Input Field
                    Expanded(
                      child: TextFormField(
                        initialValue: option.text,
                        decoration: InputDecoration(
                          hintText: 'Nhập đáp án ${index + 1}...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: (val) => vm.updateOptionText(index, val),
                      ),
                    ),

                    // Delete Button
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => vm.removeOption(index),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              );
            }),

            const SizedBox(height: 32),

            // --- Button Submit Lớn ---
             Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Lưu Câu Hỏi',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}