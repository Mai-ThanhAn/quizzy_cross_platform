import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/exam_detail_viewmodel.dart';

class ImportQuestionsSheet extends StatefulWidget {
  final String quizId;
  const ImportQuestionsSheet({super.key, required this.quizId});

  @override
  State<ImportQuestionsSheet> createState() => _ImportQuestionsSheetState();
}

class _ImportQuestionsSheetState extends State<ImportQuestionsSheet> {
  QuestionBankModel? _selectedBank;
  final _countController = TextEditingController(text: '10');
  final _scoreController = TextEditingController(text: '1.0');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExamDetailViewModel>().fetchAvailableBanks();
    });
  }

  void _onImport() async {
    if (_selectedBank == null) return;
    
    final count = int.tryParse(_countController.text) ?? 0;
    final score = double.tryParse(_scoreController.text) ?? 1.0;

    if (count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Số lượng phải lớn hơn 0')));
      return;
    }

    final vm = context.read<ExamDetailViewModel>();
    final success = await vm.importQuestionsFromBank(
      quizId: widget.quizId,
      bankId: _selectedBank!.id,
      numberOfQuestions: count,
      scorePerQuestion: score,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm câu hỏi thành công!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Lỗi')));
      }
    }
  }

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

  InputDecoration _minimalInputDecor(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
      prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent, size: 20) : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ExamDetailViewModel>();
    
    return Container(
      padding: EdgeInsets.only(
        left: 20, 
        right: 20, 
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA), // Nền xám nhạt hiện đại
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Để bottom sheet ôm nội dung
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          const Text(
            'Nhập từ Ngân hàng',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold,
              color: Colors.black87
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Section: Chọn ngân hàng
           Text(
            "NGUỒN DỮ LIỆU",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),

          _buildShadowContainer(
            child: DropdownButtonFormField<QuestionBankModel>(
              isExpanded: true, // Để text không bị lỗi overflow
              decoration: _minimalInputDecor('Chọn Ngân hàng câu hỏi', icon: Icons.folder_open_rounded),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              value: _selectedBank,
              items: vm.availableBanks.map((bank) {
                return DropdownMenuItem(
                  value: bank,
                  child: Text(
                    bank.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedBank = val;
                });
              },
            ),
          ),
          
          // Hiển thị số lượng câu hiện có
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _selectedBank != null ? 1.0 : 0.0,
            child: Padding(
               padding: const EdgeInsets.only(top: 8.0, left: 12),
               child: Row(
                 children: [
                   const Icon(Icons.info_outline, size: 14, color: Colors.blueAccent),
                   const SizedBox(width: 4),
                   Text(
                     _selectedBank != null ? 'Ngân hàng này có sẵn: ${_selectedBank!.totalQuestions} câu' : '', 
                     style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.w500)
                   ),
                 ],
               ),
             ),
          ),

          const SizedBox(height: 20),

          // Section: Cấu hình
           Text(
            "CẤU HÌNH NHẬP",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildShadowContainer(
                  child: TextField(
                    controller: _countController,
                    keyboardType: TextInputType.number,
                    decoration: _minimalInputDecor('Số câu', icon: Icons.numbers_rounded),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildShadowContainer(
                  child: TextField(
                    controller: _scoreController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: _minimalInputDecor('Điểm/câu', icon: Icons.star_border_rounded),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),

          // Button
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
              onPressed: vm.isLoading ? null : _onImport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: vm.isLoading 
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                : const Text('Xác nhận thêm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}