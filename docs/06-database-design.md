## Thiết kế Cơ sở dữ liệu Firestore cho Ứng dụng Quizzy
Tài liệu này mô tả cấu trúc các Collections và Documents cho hệ thống thi trắc nghiệm Quizzy.
--------------------------------------------------------
## 1. Tổng quan các Collections
Collection ID           Mô tả                           Vai trò chính
users                   Thông tin người dùng            Lưu profile, phân quyền (Student/Lecturer/Admin).

classes

Lớp học phần

Quản lý lớp, danh sách sinh viên trong lớp.

questions

Ngân hàng câu hỏi

Kho chứa câu hỏi gốc của giảng viên.

quizzes

Bài kiểm tra (Đề thi)

Chứa thông tin đề thi và bản sao các câu hỏi.

results

Kết quả làm bài

Lưu điểm số và chi tiết bài làm của sinh viên.
## 2. Chi tiết Cấu trúc Document

## Collection: users
Path: /users/{uid}
Lưu ý: uid trùng với User ID bên Firebase Authentication.
{
  "email": "nguyenvana@email.com",
  "fullName": "Nguyễn Văn A",
  "role": "student", // "student", "lecturer", "superadmin"
  "studentId": "222480...", // Chỉ có nếu role là student
  "avatarUrl": "https://...",
  "createdAt": Timestamp,
  "isActive": true, // Dùng để Admin khóa tài khoản (Soft delete)
  
  // [Tối ưu] Mảng chứa ID các lớp đã tham gia để query nhanh "Lớp của tôi"
  "enrolledClassIds": ["class_01", "class_02"] 
}

## Collection: classes
Path: /classes/{classId}
{
  "code": "MOB101_T123", // Mã lớp (hiển thị)
  "name": "Lập trình Di động Đa nền tảng",
  "lecturerId": "uid_lecturer_A", // Giảng viên chủ nhiệm
  "lecturerName": "Thầy B", // Lưu tên để không cần join
  "semester": "Fall 2024",
  "createdAt": Timestamp,

  // Danh sách ID sinh viên trong lớp
  // Giới hạn: Nếu lớp > 20,000 SV thì mới cần tách Sub-collection. 
  // Với quy mô lớp học bình thường, mảng này OK.
  "studentIds": ["uid_student_1", "uid_student_2"]
}

## Collection: questions (Ngân hàng câu hỏi)
Path: /questions/{questionId}
Chiến lược: Nhúng (Embed) hoàn toàn các đáp án (options) vào trong câu hỏi.
{
  "content": "Flutter là gì?",
  "type": "multiple_choice", // "single_choice", "true_false"
  "difficulty": "easy", // "medium", "hard"
  "lecturerId": "uid_lecturer_A", // Người tạo
  "createdAt": Timestamp,

  // Mảng các lựa chọn đáp án
  "options": [
    { 
      "id": "opt_1", 
      "text": "Là một SDK phát triển ứng dụng di động", 
      "isCorrect": true 
    },
    { 
      "id": "opt_2", 
      "text": "Là một cơ sở dữ liệu", 
      "isCorrect": false 
    },
    { 
      "id": "opt_3", 
      "text": "Là một ngôn ngữ lập trình", 
      "isCorrect": false 
    }
  ]
}

## Collection: quizzes (Bài kiểm tra)
Path: /quizzes/{quizId}
Chiến lược: Snapshot (Sao chép). Khi tạo đề, copy nguyên văn câu hỏi từ ngân hàng vào đây. Nếu ngân hàng sửa câu hỏi gốc, bài kiểm tra cũ không bị sai lệch.
{
  "title": "Kiểm tra giữa kỳ - 15 phút",
  "description": "Không được sử dụng tài liệu",
  "classId": "class_01", // Bài này cho lớp nào
  "lecturerId": "uid_lecturer_A",
  
  "settings": {
    "durationMinutes": 15,
    "startTime": Timestamp, // Thời gian mở đề
    "endTime": Timestamp,   // Thời gian đóng đề
    "attemptLimit": 1       // Số lần làm bài cho phép
  },
  
  "status": "published", // "draft", "published", "closed"
  "createdAt": Timestamp,

  // Danh sách câu hỏi (Đã sao chép từ collection 'questions')
  "questions": [
    {
      "id": "q1", 
      "content": "Flutter là gì?",
      "score": 1.0, // Điểm số cho câu này
      "options": [ ... ] // Các đáp án (như trên)
    },
    {
      "id": "q2",
      "content": "Dart được phát triển bởi ai?",
      "score": 1.0,
      "options": [ ... ]
    }
  ]
}

## Collection: results (Kết quả thi)
Path: /results/{resultId}
Chiến lược: Lưu chi tiết bài làm để giảng viên có thể "Review" lại từng câu chọn của sinh viên.
{
  "quizId": "quiz_01",
  "studentId": "uid_student_1",
  "studentName": "Nguyễn Văn A", // Lưu tên để hiển thị nhanh trên bảng điểm
  "studentMssv": "SV001",
  
  "score": 9.0, // Tổng điểm
  "maxScore": 10.0,
  
  "startedAt": Timestamp,
  "submittedAt": Timestamp,
  "isLate": false, // Nộp muộn hay không
  
  // Chi tiết bài làm
  "answers": [
    {
      "questionId": "q1",
      "selectedOptionId": "opt_1",
      "isCorrect": true
    },
    {
      "questionId": "q2",
      "selectedOptionId": "opt_3", // Sinh viên chọn sai
      "isCorrect": false
    }
  ]
}


## 3. Lưu ý khi triển khai
Map sang Dart Model:
Mỗi cấu trúc JSON trên nên tương ứng với một Class Model trong Flutter (ví dụ: UserModel, QuestionModel, QuizModel).
Sử dụng thư viện json_serializable để parse JSON dễ dàng.
Xử lý ngày tháng:
Firestore trả về Timestamp. Trong Flutter cần viết hàm chuyển đổi Timestamp <-> DateTime.
Bảo mật (Security Rules):
users: User chỉ được sửa profile của chính mình (request.auth.uid == userId).
quizzes: Sinh viên chỉ được đọc (Read), không được ghi (Write). Giảng viên được ghi.
results: Sinh viên chỉ được tạo (Create) kết quả của mình, không được sửa điểm.