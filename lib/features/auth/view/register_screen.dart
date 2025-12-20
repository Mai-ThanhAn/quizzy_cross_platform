import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _fullnameCtrl;
  late final TextEditingController _studentIdCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmPasswordCtrl;

  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.student;

  @override
  void initState() {
    super.initState();
    _fullnameCtrl = TextEditingController();
    _studentIdCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _fullnameCtrl.dispose();
    _studentIdCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Widget _buildInputContainer({required Widget child}) {
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
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Dark gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          /// Bottom sheet form (FIX LƠ LỬNG)
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        /// Drag indicator
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        /// Title
                        const Center(
                          child: Text(
                            'Đăng Ký Tài Khoản',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Tham gia cộng đồng Quizzy ngay',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        /// Full name
                        _buildInputContainer(
                          child: TextFormField(
                            controller: _fullnameCtrl,
                            decoration: InputDecoration(
                              labelText: 'Họ và tên',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Colors.blueAccent,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Vui lòng nhập tên của bạn'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Student ID (only student)
                        if (_selectedRole == UserRole.student) ...[
                          _buildInputContainer(
                            child: TextFormField(
                              controller: _studentIdCtrl,
                              decoration: InputDecoration(
                                labelText: 'Mã số sinh viên',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                prefixIcon: const Icon(
                                  Icons.card_membership_rounded,
                                  color: Colors.blueAccent,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Vui lòng điền MSSV'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        /// Email
                        _buildInputContainer(
                          child: TextFormField(
                            controller: _emailCtrl,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.blueAccent,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập email';
                              }
                              if (!value.contains('@')) {
                                return 'Email không hợp lệ';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Password
                        _buildInputContainer(
                          child: TextFormField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Mật khẩu',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.blueAccent,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu';
                              }
                              if (value.length < 8) {
                                return 'Mật khẩu tối thiểu 8 ký tự';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// Confirm password
                        _buildInputContainer(
                          child: TextFormField(
                            controller: _confirmPasswordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Xác nhận mật khẩu',
                              labelStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.blueAccent,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) => value != _passwordCtrl.text
                                ? 'Mật khẩu xác nhận không khớp'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Role
                        const Text(
                          'Bạn là:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: _roleButton(
                                title: 'Sinh viên',
                                selected: _selectedRole == UserRole.student,
                                onTap: () => setState(
                                  () => _selectedRole = UserRole.student,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _roleButton(
                                title: 'Giảng viên',
                                selected: _selectedRole == UserRole.lecturer,
                                onTap: () => setState(
                                  () => _selectedRole = UserRole.lecturer,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_selectedRole == UserRole.lecturer)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '* Tài khoản giảng viên cần Admin duyệt',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),

                        const SizedBox(height: 32),

                        /// Register button
                        ElevatedButton(
                          onPressed: vm.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context).unfocus();
                                  bool success = await vm.register(
                                    _fullnameCtrl.text.trim(),
                                    _studentIdCtrl.text.trim(),
                                    _emailCtrl.text.trim(),
                                    _passwordCtrl.text.trim(),
                                    _selectedRole,
                                  );

                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? (_selectedRole ==
                                                      UserRole.lecturer
                                                  ? 'Đăng ký thành công! Vui lòng chờ Admin duyệt.'
                                                  : 'Đăng ký thành công!')
                                            : (vm.errorMessage ??
                                                  'Đăng ký thất bại'),
                                      ),
                                      backgroundColor: success
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  );

                                  if (success) {
                                    Navigator.pushNamed(context, "/login");
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Đăng Ký',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Đã có tài khoản? ',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            GestureDetector(
                              onTap: vm.isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: const Text(
                                'Đăng nhập ngay',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? Colors.blueAccent.withOpacity(0.1)
              : Colors.grey[100],
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.blueAccent : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
