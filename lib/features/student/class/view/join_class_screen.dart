import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/features/student/class/viewmodel/join_class_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/class/viewmodel/class_list_viewmodel.dart'; 

class JoinClassScreen extends StatefulWidget {
  static const routeName = '/join_class';
  const JoinClassScreen({super.key});

  @override
  State<JoinClassScreen> createState() => _JoinClassScreenState();
}

class _JoinClassScreenState extends State<JoinClassScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() async {
    final vm = context.read<JoinClassViewModel>();
    final success = await vm.joinClass(_codeController.text);

    if (mounted) {
      if (success) {
        try {
           context.read<EnrolledClassesViewModel>().fetchEnrolledClasses();
        } catch (_) {}

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tham gia lớp học thành công!'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'Thất bại'), backgroundColor: Colors.red),
        );
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<JoinClassViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: const Text(
          'Tham Gia Lớp Học',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Icon & Instruction ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.vpn_key_rounded,
                  size: 48,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Nhập mã lớp học',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng nhập mã lớp do giảng viên cung cấp để tham gia vào lớp học mới.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),

            // --- Input Field ---
            _buildShadowContainer(
              child: TextField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 1.5
                ),
                textAlign: TextAlign.center, // Căn giữa mã số cho đẹp
                decoration: InputDecoration(
                  hintText: 'VD: A1B2C3',
                  hintStyle: TextStyle(
                    color: Colors.grey[400], 
                    fontSize: 16, 
                    fontWeight: FontWeight.normal,
                    letterSpacing: 0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  prefixIcon: const Icon(Icons.qr_code_rounded, color: Colors.blueAccent),
                ),
              ),
            ),
            
            const SizedBox(height: 40),

            // --- Submit Button ---
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
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                    ) 
                  : const Text(
                      'Xác Nhận Tham Gia',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}