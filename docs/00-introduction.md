Problem Statement
Nhiều hệ thống thi trắc nghiệm hiện đang chỉ chạy trên web hoặc chỉ trên mobile, gây ra sự phân mảnh trong trải nghiệm người dùng. Ngoài ra, sinh viên thường chỉ cần giao diện mobile để thao tác nhanh, trong khi giảng viên và ban quản trị lại cần giao diện quản trị màn hình lớn. Việc triển khai đa nền tảng bình thường cần nhiều codebase khác nhau, tốn thời gian và khó bảo trì.
==================================================================================================================
Why this project? (Rationale)
Một codebase duy nhất nhưng có thể build ra mobile và web → phù hợp xu hướng phát triển đa nền tảng
Flutter + Firebase phù hợp demo học thuật nhưng vẫn có tính thực tiễn
Hệ thống dễ mở rộng về sau (AI scoring, auto question generation…)
Bản thân nhóm muốn tối ưu thời gian triển khai, tập trung nhiều hơn vào logic xử lý và trải nghiệm người dùng thay vì xây dựng backend phức tạp
==================================================================================================================
Objectives
Xây dựng hệ thống thi trắc nghiệm đa nền tảng với đầy đủ 3 vai trò chính
Tích hợp Firebase để xử lý xác thực và dữ liệu real-time
Thiết kế giao diện rõ ràng, dễ sử dụng, thân thiện cho cả mobile và web
Phân tách cấu trúc dự án theo module để dễ quản lý và mở rộng sau này
==================================================================================================================
Scope (In-Scope / Out-Of-Scope) 
In-Scope
Mobile App cho Sinh viên (Flutter build Android)
Web App cho Giảng viên & Super Admin (Flutter Web)
Firebase Authentication
Firebase Firestore Database
Chức năng quản lý câu hỏi, đề kiểm tra, lớp học, kết quả thi
Xuất điểm ra file Excel
Phân quyền theo role (Student / Teacher / Admin)
Out-Of-Scope
Chấm thi tự luận
Offline mode
AI tự động sinh câu hỏi (đề xuất tương lai)
==================================================================================================================
Stakeholders
========================================================================
| Stakeholder         | Vai trò                                        |
| ------------------- | ---------------------------------------------- |
| Sinh viên           | Sử dụng mobile để làm bài trắc nghiệm          |
| Giảng viên          | Quản lý ngân hàng câu hỏi, tạo đề, xem kết quả |
| Super Admin         | Quản lý tài khoản hệ thống                     |
| Giáo viên hướng dẫn | Theo dõi tiến độ và đánh giá dự án             |
| Người phát triển    | Người trực tiếp xây dựng sản phẩm              |
========================================================================