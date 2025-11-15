import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizzy_cross_platform/features/auth/view/forgotpassword_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/login_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/register_screen.dart';
import 'package:quizzy_cross_platform/features/student/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/', // màn hình khởi đầu
      routes: {
        '/': (context) => const LoginScreen(),
        '/homestudent': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgotpass': (context) => const ForgotpasswordScreen(),
      },
    );
  }
}
