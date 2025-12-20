import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/core/constants/colors.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/login_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/profie_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _studentIdCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _roleCtrl = TextEditingController();
    _studentIdCtrl = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfieViewmodel>().fechUserProfile();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _roleCtrl.dispose();
    _studentIdCtrl.dispose();
    super.dispose();
  }

  // --- UI HELPER WIDGETS ---

  Widget _buildShadowContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isLast = false,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          readOnly: true, // Giả định là xem hồ sơ, nếu cần sửa có thể bỏ dòng này
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.7), size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pvm = context.watch<ProfieViewmodel>();
    final lvm = context.watch<LoginViewmodel>();

    if (pvm.currentUser != null) {
      _nameCtrl.text = pvm.currentUser!.fullName;
      _emailCtrl.text = pvm.currentUser!.email;
      _roleCtrl.text = pvm.currentUser!.role == 'student' ? 'Sinh viên' : 'Giảng viên';
      _studentIdCtrl.text = pvm.currentUser!.studentId ?? '';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Nền xám hiện đại
      appBar: AppBar(
        title: const Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: pvm.isLoading && pvm.currentUser == null
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : pvm.errorMessage != null
              ? Center(child: Text('Lỗi: ${pvm.errorMessage}'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      // --- Avatar Section ---
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 55,
                              backgroundImage: AssetImage("assets/images/avatar_placeholder.png"), // Dùng placeholder hoặc ảnh thật
                              backgroundColor: Color(0xFFE3F2FD),
                              child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 4, right: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      Text(
                        _nameCtrl.text,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        _emailCtrl.text,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),

                      const SizedBox(height: 32),

                      // --- Info Card ---
                      _buildShadowContainer(
                        child: Column(
                          children: [
                            _buildProfileField(
                              label: 'Họ và tên',
                              icon: Icons.person_outline_rounded,
                              controller: _nameCtrl,
                            ),
                            _buildProfileField(
                              label: 'Email',
                              icon: Icons.email_outlined,
                              controller: _emailCtrl,
                            ),
                            _buildProfileField(
                              label: 'Vai trò',
                              icon: Icons.badge_outlined,
                              controller: _roleCtrl,
                              isLast: pvm.currentUser?.role != 'student',
                            ),
                            if (pvm.currentUser?.role == 'student')
                              _buildProfileField(
                                label: 'Mã số sinh viên',
                                icon: Icons.school_outlined,
                                controller: _studentIdCtrl,
                                isLast: true,
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // --- Logout Button ---
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: lvm.isLoading
                              ? null
                              : () async {
                                  bool success = await lvm.logout();
                                  if (success) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Đăng xuất thành công, hẹn gặp lại nhé!",
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(context, '/login');
                                  } else {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          lvm.errorMessage ?? 'Đăng xuất thất bại',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.redAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: lvm.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.redAccent),
                                )
                              : const Icon(Icons.logout_rounded),
                          label: Text(
                            lvm.isLoading ? 'Đang xử lý...' : 'Đăng Xuất',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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