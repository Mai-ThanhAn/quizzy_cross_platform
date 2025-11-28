import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Khai báo controllers cho các trường nhập liệu
  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmPasswordCtrl;
  UserRole _selectedRole = UserRole.student;
  final _formKey = GlobalKey<FormState>();
  // late final = giá trị sẽ được gán một lần, nhưng không cần khởi tạo ngay lúc khai báo.

  // 2. Khởi tạo và hủy controllers
  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
  }

  // 3. Dọn dẹp controllers
  // bất cứ màn hình nào dùng TextEditingController đều nên gọi dispose() trong State.
  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Nội dung phía dưới
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Chào mừng bạn đến với Quizzy!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Xác nhận mật khẩu',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Lựa chọn Vai trò (AUTH-STU-Register vs AUTH-TEA-Register)
                      const Text('Bạn là:', style: TextStyle(fontSize: 16)),
                      RadioListTile<UserRole>(
                        title: const Text('Sinh viên'),
                        value: UserRole.student,
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      RadioListTile<UserRole>(
                        title: const Text('Giảng viên'),
                        subtitle: _selectedRole == UserRole.lecturer
                            ? const Text(
                                '(Tài khoản cần được Super Admin duyệt)',
                                style: TextStyle(color: Colors.orange),
                              )
                            : null,
                        value: UserRole.lecturer,
                        groupValue: _selectedRole,
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Nút Đăng ký
                      ElevatedButton(
                        onPressed: () {
                          if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mật khẩu xác nhận không khớp'),
                              ),
                            );
                            return;
                          }

                          context.read<RegisterViewModel>().register(
                            _emailCtrl.text.trim(),
                            _passwordCtrl.text.trim(),
                            _selectedRole,
                            context,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Đăng ký'),
                      ),
                      const SizedBox(height: 16),

                      // Quay lại Đăng nhập
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
