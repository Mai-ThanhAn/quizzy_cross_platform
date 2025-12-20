import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/create_exam_viewmodel.dart';

class CreateExamScreen extends StatefulWidget {
  final String classId;

  const CreateExamScreen({super.key, required this.classId});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _durationController = TextEditingController(text: '45');
  final _attemptController = TextEditingController(text: '1');

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _durationController.dispose();
    _attemptController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(bool isStart) async {
    final vm = context.read<CreateExamViewModel>();
    final initialDate = isStart ? vm.startTime : vm.endTime;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
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
      final vm = context.read<CreateExamViewModel>();

      final success = await vm.createQuiz(
        classId: widget.classId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        durationMinutes: int.tryParse(_durationController.text) ?? 15,
        attemptLimit: int.tryParse(_attemptController.text) ?? 1,
      );

      if (mounted) {
        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo bài kiểm tra thành công!')),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(vm.errorMessage ?? 'Lỗi')));
        }
      }
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

  InputDecoration _minimalInputDecor(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateExamViewModel>();
    final dateFormat = DateFormat('dd/MM/yyyy • HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám nhạt hiện đại
      appBar: AppBar(
        title: const Text(
          'Tạo Đề Thi Mới',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Section: Thông tin ---
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
                  decoration: _minimalInputDecor('Tiêu đề bài kiểm tra',
                      icon: Icons.assignment),
                  validator: (v) => v!.isEmpty ? 'Nhập tiêu đề' : null,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              _buildShadowContainer(
                child: TextFormField(
                  controller: _descController,
                  decoration: _minimalInputDecor('Mô tả nội dung',
                      icon: Icons.description_outlined),
                  maxLines: 3,
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
                      child: TextFormField(
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                        decoration: _minimalInputDecor('Phút',
                            icon: Icons.timer_outlined),
                        validator: (v) => (int.tryParse(v!) ?? 0) <= 0
                            ? 'Sai thời gian'
                            : null,
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
                "LỊCH TRÌNH",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 10),

              _buildTimeCard(
                title: 'Thời gian mở đề',
                timeStr: dateFormat.format(vm.startTime),
                icon: Icons.calendar_today_outlined,
                onTap: () => _pickDateTime(true),
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              _buildTimeCard(
                title: 'Thời gian đóng đề',
                timeStr: dateFormat.format(vm.endTime),
                icon: Icons.event_busy_outlined,
                onTap: () => _pickDateTime(false),
                color: Colors.redAccent,
                isError: vm.endTime.isBefore(vm.startTime),
              ),

              // Hiển thị lỗi nếu ngày sai
              if (vm.endTime.isBefore(vm.startTime))
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Thời gian kết thúc phải sau thời gian bắt đầu',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              // --- Button Submit ---
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
                          'Tiếp tục',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard({
    required String title,
    required String timeStr,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool isError = false,
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
                    color: isError ? Colors.red.withOpacity(0.1) : color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: isError ? Colors.red : color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isError ? Colors.red : Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: isError ? Colors.red : Colors.black87,
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
}