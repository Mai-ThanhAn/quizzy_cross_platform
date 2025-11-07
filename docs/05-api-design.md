Đây là mô tả sơ lược về API có sử dụng cho hệ thống: {dự kiến} - mang tính tham khảo sơ lược
==================================================================================================================
1.Firebase Authentication (API Xác thực)
Vai trò: Đây là dịch vụ quản lý toàn bộ "danh tính" người dùng. Nó không phải là một API gọi trực tiếp qua HTTP, mà sẽ dùng SDK của Firebase (một bộ công cụ đóng gói sẵn API) trong Flutter.
Cách hoạt động:
Khi người dùng Đăng ký (UC-STU02, UC-TEA02),  gọi hàm createUserWithEmailAndPassword() từ SDK. Firebase sẽ tự động băm (hash) mật khẩu và tạo một User ID (UID) duy nhất.
Khi người dùng Đăng nhập (UC-STU01),  gọi hàm signInWithEmailAndPassword(). Firebase xác thực và trả về thông tin người dùng, cấp cho họ một "phiên làm việc" (session token).
Nó cũng xử lý các luồng phức tạp như "Quên mật khẩu" (UC-STU05) bằng cách tự động gửi email reset.
==================================================================================================================
2.Firebase Firestore (API Cơ sở dữ liệu)
Vai trò: Đây là cơ sở dữ liệu (database) NoSQL của . Giống như Authentication,  sẽ dùng SDK của Firestore để tương tác, thay vì gọi API RESTful truyền thống.
Cách hoạt động:
Dữ liệu được tổ chức thành các Collections (như thư mục, ví dụ: 'users', 'quizzes', 'classes') và Documents (như file, ví dụ: 'student_A', 'quiz_01').
Ghi dữ liệu (Write): Khi Giảng viên Tạo lớp (UC-TEA13),  dùng hàm .set() hoặc .add() để tạo một Document mới trong Collection 'classes'.
Đọc dữ liệu (Read): Khi Sinh viên Mở ứng dụng (UC-STU09),  dùng hàm .get() để "truy vấn" (query) Collection 'quizzes' và lấy về các bài kiểm tra được gán cho lớp của họ.
==================================================================================================================
3. OpenAI API (cho ChatGPT - API Trí tuệ nhân tạo)
Vai trò: Cung cấp khả năng xử lý ngôn ngữ tự nhiên, cụ thể là "giải thích đáp án sai" (UC-STU13).
Cách hoạt động:
Đây là một API RESTful chuẩn. Ứng dụng sẽ gửi một yêu cầu HTTP POST đến máy chủ của OpenAI.
 sẽ gửi đi một "prompt" (câu lệnh) có cấu trúc, ví dụ: "Đây là câu hỏi trắc nghiệm: [Câu hỏi]. Đáp án đúng là [A]. Sinh viên chọn [B]. Hãy giải thích tại sao [B] sai và [A] đúng."
API của OpenAI sẽ xử lý prompt này bằng mô hình (ví dụ: GPT-3.5-Turbo) và trả về một chuỗi JSON chứa nội dung văn bản giải thích.