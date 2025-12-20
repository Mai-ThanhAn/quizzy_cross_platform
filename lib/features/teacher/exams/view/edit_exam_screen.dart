import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/edit_exam_viewmodel.dart';

class EditExamScreen extends StatefulWidget {
  final QuizModel quiz;

  const EditExamScreen({super.key, required this.quiz});

  @override
  State<EditExamScreen> createState() => _EditExamScreenState();
}

class _EditExamScreenState extends State<EditExamScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _durationController;
  late TextEditingController _attemptController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.quiz.title);
    _descController = TextEditingController(text: widget.quiz.description);
    _durationController = TextEditingController(
      text: widget.quiz.settings.durationMinutes.toString(),
    );
    _attemptController = TextEditingController(
      text: widget.quiz.settings.attemptLimit.toString(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EditExamViewModel>().initialize(widget.quiz);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _attemptController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final vm = context.read<EditExamViewModel>();
    final initialDate = isStart ? vm.startTime : vm.endTime;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.orange),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    final combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (isStart) {
      vm.setStartTime(combined);
    } else {
      vm.setEndTime(combined);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final vm = context.read<EditExamViewModel>();

      final success = await vm.updateQuiz(
        originalQuiz: widget.quiz,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        durationMinutes: int.tryParse(_durationController.text) ?? 15,
        attemptLimit: int.tryParse(_attemptController.text) ?? 1,
      );

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Lỗi')));
        }
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
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: Colors.orange) : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.orange, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditExamViewModel>();
    final dateFormat = DateFormat('dd/MM/yyyy • HH:mm');
    final displayStart =
        tryCatchDate(() => vm.startTime) ?? widget.quiz.settings.startTime;
    final displayEnd =
        tryCatchDate(() => vm.endTime) ?? widget.quiz.settings.endTime;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Bài Kiểm Tra',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Section: Thông tin chung ---
              Text(
                "THÔNG TIN CƠ BẢN",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),

              _buildShadowContainer(
                child: TextFormField(
                  controller: _titleController,
                  decoration: _minimalInputDecor('Tiêu đề bài thi',
                      icon: Icons.assignment_outlined),
                  validator: (v) => v!.isEmpty ? 'Nhập tiêu đề' : null,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              _buildShadowContainer(
                child: TextFormField(
                  controller: _descController,
                  decoration:
                      _minimalInputDecor('Mô tả nội dung', icon: Icons.description_outlined),
                  maxLines: 3,
                  minLines: 1,
                ),
              ),
              
              const SizedBox(height: 24),

              // --- Section: Cấu hình ---
              Text(
                "CẤU HÌNH",
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
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: _minimalInputDecor('Phút',
                            icon: Icons.timer_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildShadowContainer(
                      child: TextFormField(
                        controller: _attemptController,
                        keyboardType: TextInputType.number,
                        decoration: _minimalInputDecor('Lượt làm',
                            icon: Icons.loop),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- Section: Thời gian ---
              Text(
                "THỜI GIAN",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),

              // Bắt đầu
              _buildTimeCard(
                title: 'Thời gian mở đề',
                timeStr: dateFormat.format(displayStart),
                icon: Icons.calendar_today_outlined,
                onTap: () => _pickDateTime(true),
                color: Colors.blueAccent,
              ),
              
              const SizedBox(height: 12),

              // Kết thúc
              _buildTimeCard(
                title: 'Thời gian đóng đề',
                timeStr: dateFormat.format(displayEnd),
                icon: Icons.event_busy_outlined,
                onTap: () => _pickDateTime(false),
                color: Colors.redAccent,
              ),

              const SizedBox(height: 40),

              // --- Button Submit ---
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: vm.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0, // Tắt shadow mặc định của Material để dùng shadow custom
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: vm.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Lưu Thay Đổi',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con hiển thị chọn giờ
  Widget _buildTimeCard({
    required String title,
    required String timeStr,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return _buildShadowContainer(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeStr,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.edit, color: Colors.grey[400], size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? tryCatchDate(DateTime Function() func) {
    try {
      return func();
    } catch (e) {
      return null;
    }
  }
}