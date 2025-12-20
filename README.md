# Quizzy – Cross Platform Exam System (Flutter + Firebase)

Ứng dụng thi trắc nghiệm đa nền tảng (mobile + web) xây dựng bằng Flutter, sử dụng Firebase làm backend.  
Mục tiêu là giúp sinh viên làm bài kiểm tra trực tuyến, giảng viên quản lý đề thi và xem kết quả trên web.

## Features
- Sinh viên làm bài thi trắc nghiệm
- Hỗ trợ sinh viên giải thích đáp án sai bằng trí tuệ nhân tạo
- Giảng viên quản lý đề thi và xem kết quả
- Super Admin quản trị hệ thống
- Đăng nhập bằng tài khoản hệ thống / google auth
- Realtime sync với Firebase

## Screenshot main features
## Authentication - Xác Thực
- Welcome Screen 
![alt text](screenshots/screenshots/image.png)
- Login
![alt text](screenshots/screenshots/image-1.png)
- Register
![alt text](screenshots/image-2.png)
- ForgotPass
![alt text](screenshots/image-3.png)
## Student - Sinh Viên
- Main Screen
![alt text](screenshots/image-4.png)
- Profile Screen
![alt text](screenshots/image-5.png)
- Class List Screen
![alt text](screenshots/image-6.png)
- Detail Class Screen
![alt text](screenshots/image-7.png)
- Do Quiz Screen

## Lecturer - Giảng Viên [Teacher]
- Main Screen
![alt text](screenshots/image-8.png)
- Profile Screen
![alt text](screenshots/image-9.png)
- Class Screen
![alt text](screenshots/image-10.png)
- Create Class
![alt text](screenshots/image-11.png)
- Detail Class Screen
![alt text](screenshots/image-12.png)
- Detail Quiz
![alt text](screenshots/image-13.png)
- Config Quiz
![alt text](screenshots/image-14.png)
- Import Question From Bank To Quiz
![alt text](screenshots/image-21.png)
- Change Status Quiz
![alt text](screenshots/image-22.png)
- Result Screen
![alt text](screenshots/image-16.png)
- Bank Questons Screen
![alt text](screenshots/image-17.png)
- Create Bank Question
![alt text](screenshots/image-18.png)
- Detail Bank Question
![alt text](screenshots/image-19.png)
- Add Question To Bank
![alt text](screenshots/image-20.png)

## Admin - Quản Trị Viên
- Main Screen
![alt text](screenshots/image-23.png)
- Accept Request From Lecturer
![alt text](screenshots/image-26.png)
- Lock Account
![alt text](screenshots/image-25.png)

## Demo Video
https://youtu.be/iThdrS386gM

## Tech Stack
- Flutter (Dart)
- Firebase Auth
- Firebase Firestore
- MVVM Architecture

## Architecture
Project được tổ chức theo kiến trúc MVVM và chia module theo tuần (sprint).

## Folder Structure
/docs → chứa tài liệu project (.md)
/lib → source code chính flutter

## Roadmap / Weekly Progress
Roadmap chi tiết được lập kế hoạch và quản lý tại Jira: 
https://trello.com/invite/b/6909a1bbba80cacd516fbf89/ATTI17b3519fe9129702b6d4cb4813b5112aD5F83220/quizzy-cross-platform-project

## Contact
- Author: Mai Thanh An
- University: Trường Đại Học Thủ Dầu Một
- Academic year: 2022 - 2027
- Email: maian250704@gmail.com
