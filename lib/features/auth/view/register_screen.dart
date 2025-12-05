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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 90,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Chào mừng bạn đến với Quizzy!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // FullName
                      TextFormField(
                        controller: _fullnameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Họ Và Tên',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên của bạn nhé';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // StudentId
                      TextFormField(
                        controller: _studentIdCtrl,
                        decoration: const InputDecoration(
                          labelText: 'MSSV',
                          prefixIcon: Icon(Icons.card_membership_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng điền MSSV của bạn';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) return 'Email không hợp lệ';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          }
                          if (value.length < 8)
                          {
                            return 'Mật khẩu tối thiểu 8 ký tự';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm
                      TextFormField(
                        controller: _confirmPasswordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Xác nhận mật khẩu',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value != _passwordCtrl.text) {
                            return 'Mật khẩu xác nhận không khớp';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Roles
                      const Text('Bạn là:', style: TextStyle(fontSize: 16)),
                      RadioListTile<UserRole>(
                        title: const Text('Sinh viên'),
                        value: UserRole.student,
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v!),
                      ),
                      RadioListTile<UserRole>(
                        title: const Text('Giảng viên'),
                        subtitle: _selectedRole == UserRole.lecturer
                            ? const Text(
                                '(Tài khoản cần Super Admin duyệt)',
                                style: TextStyle(color: Colors.orange),
                              )
                            : null,
                        value: UserRole.lecturer,
                        groupValue: _selectedRole,
                        onChanged: (v) => setState(() => _selectedRole = v!),
                      ),
                      const SizedBox(height: 24),

                      // Button Register
                      ElevatedButton(
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();

                                // Call to viewmodel
                                bool success = await vm.register(
                                  _fullnameCtrl.text.trim(),
                                  _studentIdCtrl.text.trim(),
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                  _selectedRole,
                                );

                                if (success) {
                                  if (!context.mounted) return;

                                  String msg =
                                      _selectedRole == UserRole.lecturer
                                      ? 'Đăng ký thành công! Vui lòng chờ Admin duyệt.'
                                      : 'Đăng ký thành công!';

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(msg),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pushNamed(context, "/login");
                                } else {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        vm.errorMessage ?? 'Đăng ký thất bại',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: vm.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Register'),
                      ),

                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: vm.isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: const Text('Đã có tài khoản? Đăng nhập'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
