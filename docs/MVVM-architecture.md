```
└── 📁lib
    └── 📁app
        ├── app.dart                       //App khởi tạo chính (MaterialApp, Provider setup vv)
        ├── routes.dart                    //Khai báo route / điều hướng giữa màn hình
    └── 📁core                            
        └── 📁constants                   //Chứa hằng số chung trong dự án (text, số, đường dẫn,…)
        └── 📁errors                      //Xử lý exception / custom error
        └── 📁utils                       //Hàm tiện ích dùng chung (format datetime, validate email,…)
        └── 📁widgets                     //Reusable UI chung, không phụ thuộc feature cụ thể
    └── 📁data                            
        └── 📁models                      //Data model (User, Quiz, Question …)
        └── 📁repositories                //Business logic / tổng hợp service, quyết định lấy data từ đâu
        └── 📁services                    //Code gọi Firebase / API / local storage
    └── 📁features                        
        └── 📁auth                        //chức năng Login/Register
            └── 📁view                    //UI / màn hình
            └── 📁viewmodel               //logic / state của feature đó
            └── 📁widgets                 //UI con chỉ dùng riêng cho feature đó
        └── 📁lecturer                    //chức năng dành cho giảng viên
        └── 📁student                     //chức năng dành cho sinh viên
        └── 📁superadmin                  //chức năng quản trị hệ thống
    └── 📁theme                           //Chứa file cấu hình (colors, textstyle, theme cho MaterialApp)
    └── main.dart
```