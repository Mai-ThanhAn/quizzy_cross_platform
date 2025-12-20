import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:quizzy_cross_platform/app/app.dart';
import 'package:quizzy_cross_platform/domain/usecases/get_all_student_quizzes_usecase.dart';
import 'package:quizzy_cross_platform/features/admin/viewmodel/admin_dashboard_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/login_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/register_viewmodel.dart';
import 'package:quizzy_cross_platform/features/auth/viewmodel/profie_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/class/repository/class_repository.dart';
import 'package:quizzy_cross_platform/features/student/class/viewmodel/class_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/class/viewmodel/join_class_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/home/viewmodel/student_home_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/quiz/repository/quiz_repository.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/do_quiz_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/quiz_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/student/quiz/viewmodel/student_class_detail_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/viewmodel/class_detail_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/viewmodel/create_class_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/viewmodel/teacher_class_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/create_exam_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/edit_exam_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/exam_detail_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/quiz_results_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/viewmodel/teacher_exam_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/home/viewmodel/teacher_home_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/bank_list_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/create_question_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/edit_question_viewmodel.dart';
import 'package:quizzy_cross_platform/features/teacher/question_bank/viewmodel/question_list_viewmodel.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        // Provider For Auth
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewmodel()),
        ChangeNotifierProvider(create: (_) => ProfieViewmodel()),

        // Provider For Student
        ChangeNotifierProvider(create: (_) => StudentHomeViewModel()),
        ChangeNotifierProvider(create: (_) => EnrolledClassesViewModel()),
        ChangeNotifierProvider(create: (_) => JoinClassViewModel()),
        ChangeNotifierProvider(create: (_) => StudentClassDetailViewModel()),
        ChangeNotifierProvider(create: (_) => DoQuizViewModel()),
        ChangeNotifierProvider(
          create: (_) {
            final classRepo = ClassRepository();
            final quizRepo = QuizRepository();
            final useCase = GetAllStudentQuizzesUseCase(classRepo, quizRepo);
            return QuizListViewModel(useCase);
          },
        ),

        // Provider For Teacher [Lecture]
        ChangeNotifierProvider(create: (_) => TeacherHomeViewModel()),
        ChangeNotifierProvider(create: (_) => CreateClassViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherClassListViewModel()),
        ChangeNotifierProvider(create: (_) => ClassDetailViewModel()),

        ChangeNotifierProvider(create: (_) => TeacherExamListViewModel()),
        ChangeNotifierProvider(create: (_) => CreateExamViewModel()),
        ChangeNotifierProvider(create: (_) => EditExamViewModel()),
        ChangeNotifierProvider(create: (_) => ExamDetailViewModel()),
        ChangeNotifierProvider(create: (_) => QuizResultsViewModel()),

        ChangeNotifierProvider(create: (_) => BankListViewModel()),
        ChangeNotifierProvider(create: (_) => QuestionListViewModel()),
        ChangeNotifierProvider(create: (_) => CreateQuestionViewModel()),
        ChangeNotifierProvider(create: (_) => EditQuestionViewModel()),

        // Provider For Admin
        ChangeNotifierProvider(create: (_) => AdminDashboardViewModel()),
      ],
      child: MyApp(),
    ),
  );
}
