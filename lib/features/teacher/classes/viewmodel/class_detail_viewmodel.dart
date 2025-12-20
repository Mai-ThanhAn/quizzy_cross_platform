import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizzy_cross_platform/data/models/quizzes_model.dart';
import 'package:quizzy_cross_platform/data/models/users_model.dart';
import 'package:quizzy_cross_platform/features/teacher/classes/repository/teacher_class_repository.dart';
import 'package:quizzy_cross_platform/features/teacher/exams/repository/teacher_exam_repository.dart';

class ClassDetailViewModel extends ChangeNotifier {
  final TeacherClassRepository _teacherClassRepo = TeacherClassRepository();
  final TeacherExamRepository _examRepo = TeacherExamRepository();

  bool isLoading = false;
  String? errorMessage;

  List<UserModel> _students = [];
  List<UserModel> get students => _students;

  List<QuizModel> _exams = [];
  List<QuizModel> get exams => _exams;

  Future<void> fetchStudents(List<String> studentIds) async {
    if (studentIds.isEmpty) {
      _students = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      _students = await _teacherClassRepo.getStudentsInClass(studentIds);
    } catch (e) {
      errorMessage = 'Không tải được danh sách sinh viên';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteClass(String classId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _teacherClassRepo.deleteClass(classId);
      return true;
    } catch (e) {
      errorMessage = 'Lỗi khi xóa lớp học';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> copyClassCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
  }

  Future<void> fetchExams(String classId) async {
    isLoading = true;
    notifyListeners();
    try {
      _exams = await _examRepo.getQuizzesByClassId(classId);
    } catch (e) {
      errorMessage = 'Không tải được danh sách bài kiểm tra';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
