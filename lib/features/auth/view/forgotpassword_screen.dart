import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Cấu hình thanh trạng thái trong suốt
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forgot Password',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        // Màu nền mặc định cho toàn app
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: const ForgotPasswordScreen(),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // 1. Khai báo controllers cho các trường nhập liệu
  late final TextEditingController _emailController;

  // Định nghĩa bảng màu
  final Color primaryColor = const Color(0xFF4A90E2); // #4A90E2 (Xanh dương)
  final Color textMain = const Color(0xFF333333);     // #333333 (Đen xám)
  final Color textSecondary = const Color(0xFF666666);// #666666 (Xám nhạt)
  final Color inputBorder = const Color(0xFFD1D5DB);  // Gray-300 (Viền xám)

  // 2. Khởi tạo controllers
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  // 3. Dọn dẹp controllers để tránh rò rỉ bộ nhớ
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea giúp nội dung không bị lẹm vào tai thỏ
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // --- PHẦN 1: HEADER ICON (Hình tròn chứa icon thư) ---
                Container(
                  width: 96, // w-24
                  height: 96,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mark_email_unread_outlined,
                      color: primaryColor,
                      size: 48, // Icon lớn
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- PHẦN 2: TIÊU ĐỀ & MÔ TẢ ---
                Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: textMain,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Enter your registered email to receive a password reset link.",
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5, // Khoảng cách dòng dễ đọc
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // --- PHẦN 3: FORM NHẬP LIỆU (Hộp trắng đổ bóng) ---
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 480), // Giới hạn chiều rộng trên tablet/web
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label "Email"
                      Text(
                        "Email",
                        style: TextStyle(
                          color: textMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Custom Input Field: Kết hợp IconBox (trái) và TextField (phải)
                      Row(
                        children: [
                          // Hộp chứa Icon
                          Container(
                            height: 56, // Chiều cao cố định
                            width: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB), // Nền xám nhẹ
                              border: Border(
                                top: BorderSide(color: inputBorder),
                                bottom: BorderSide(color: inputBorder),
                                left: BorderSide(color: inputBorder),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Icon(
                              Icons.mail_outline,
                              color: textSecondary,
                              size: 24,
                            ),
                          ),
                          
                          // Hộp chứa TextField nhập liệu
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                border: Border.all(color: inputBorder),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                style: TextStyle(color: textMain),
                                decoration: InputDecoration(
                                  hintText: "Enter registered email",
                                  hintStyle: TextStyle(color: textSecondary),
                                  border: InputBorder.none, // Tắt viền mặc định
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Nút "Send Reset Link"
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Xử lý logic gửi email tại đây
                            print("Gửi link reset tới: ${_emailController.text}");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Nút quay lại "Back to Login"
                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Xử lý quay lại màn hình Login
                            print("Quay lại màn hình đăng nhập");
                          },
                          child: Text(
                            "Back to Login",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}