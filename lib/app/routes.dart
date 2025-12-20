import 'package:flutter/material.dart';
import 'package:quizzy_cross_platform/data/models/classes_model.dart';
import 'package:quizzy_cross_platform/data/models/question_bank_model.dart';
import 'package:quizzy_cross_platform/data/models/questions_model.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/features/admin/view/admin_dashboard_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/forgotpassword_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/login_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/profile_screen.dart';
import 'package:quizzy_cross_platform/features/auth/view/register_screen.dart';
import 'package:quizzy_cross_platform/features/student/class/view/join_class_screen.dart';
import 'package:quizzy_cross_platform/features/student/home/view/welcome_screen.dart';
import 'package:quizzy_cross_platform/features/student/home_screen.dart';
import 'package:quizzy_cross_platform/features/student/quiz/view/do_quiz_screen.dart';
import 'package:quizzy_cross_platform/features/student/quiz/view/student_class_detail_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/view/class_detail_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/view/create_class_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/view/teacher_class_list_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/view/create_exam_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/view/edit_exam_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/view/exam_detail_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/view/quiz_results_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/view/create_question_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/view/edit_question_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/view/question_list_screen.dart';
import 'package:quizzy_cross_platform/features/teacher/teacher_home_screen.dart';

class AppRoutes {
  static const String welcome = '/';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case '/forgotpass':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case '/homestudent':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/join_class':
        return MaterialPageRoute(builder: (_) => const JoinClassScreen());

      case '/hometeacher':
        final index = settings.arguments as int?;

        return MaterialPageRoute(
          builder: (_) => TeacherHomeScreen(initialIndex: index ?? 0),
        );

      case '/homeadmin':
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case '/classesteacher':
        return MaterialPageRoute(
          builder: (_) => const TeacherClassListScreen(),
        );

      case '/create_class':
        return MaterialPageRoute(builder: (_) => const CreateClassScreen());

      case '/class_detail':
        final args = settings.arguments;
        if (args is! ClassModel) {
          return _errorRoute('Thiếu dữ liệu lớp học');
        }
        return MaterialPageRoute(
          builder: (_) => ClassDetailScreen(classModel: args),
        );

      case '/student_class_detail':
        final args = settings.arguments;
        if (args is! ClassModel) {
          return _errorRoute('Thiếu dữ liệu lớp học');
        }
        return MaterialPageRoute(
          builder: (_) => StudentClassDetailScreen(classModel: args),
        );

      case '/create_exam':
        final args = settings.arguments;
        if (args is! String) {
          return _errorRoute('Thiếu classId');
        }
        return MaterialPageRoute(
          builder: (_) => CreateExamScreen(classId: args),
        );

      case '/edit_exam':
        final quiz = settings.arguments;
        if (quiz is! QuizModel) {
          return _errorRoute('Thiếu dữ liệu bài kiểm tra');
        }
        return MaterialPageRoute(builder: (_) => EditExamScreen(quiz: quiz));

      case '/exam_detail':
        final quizId = settings.arguments;
        if (quizId is! String) {
          return _errorRoute('Thiếu dữ liệu bài kiểm tra');
        }
        return MaterialPageRoute(
          builder: (_) => ExamDetailScreen(quizId: quizId),
        );

      case '/do_quiz':
        final quiz = settings.arguments;
        if (quiz is! QuizModel) {
          return _errorRoute('Thiếu dữ liệu bài kiểm tra');
        }
        return MaterialPageRoute(builder: (_) => DoQuizScreen(quiz: quiz));

      case '/questions_in_bank':
        final bank = settings.arguments;
        if (bank is! QuestionBankModel) {
          return _errorRoute('Thiếu dữ liệu ngân hàng câu hỏi');
        }
        return MaterialPageRoute(
          builder: (_) => QuestionListScreen(bank: bank),
        );

      case '/create_question':
        final bankId = settings.arguments;
        if (bankId is! String) {
          return _errorRoute('Thiếu dữ liệu mã ngân hàng câu hỏi');
        }
        return MaterialPageRoute(
          builder: (_) => CreateQuestionScreen(bankId: bankId),
        );

      case '/edit_question':
        final question = settings.arguments;
        if (question is! QuestionModel) {
          return _errorRoute('Thiếu dữ liệu câu hỏi');
        }
        return MaterialPageRoute(
          builder: (_) => EditQuestionScreen(question: question),
        );

      case '/quiz_results':
        final quiz = settings.arguments;
        if (quiz is! QuizModel) {
          return _errorRoute('Thiếu dữ liệu bài kiểm tra');
        }
        return MaterialPageRoute(builder: (_) => QuizResultsScreen(quiz: quiz));

      default:
        return _errorRoute('Route không tồn tại');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Lỗi')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
