import 'package:flutter/material.dart';
import 'db_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordComfirmController =
      TextEditingController();
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordComfirmController,
              decoration: InputDecoration(labelText: 'Xác nhận Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _register();
              },
              child: Text('Đăng ký'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String passwordcomfirm = _passwordComfirmController.text.trim();
    if (password == passwordcomfirm) {
      if (username.isEmpty || password.isEmpty) {
        // Hiển thị thông báo lỗi khi thông tin đăng ký không hợp lệ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng nhập đầy đủ thông tin đăng ký.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phải nhập trùng khớp với mật khẩu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Kiểm tra xem tên đăng nhập đã tồn tại chưa
    if (await _dbHelper.isUsernameExists(username)) {
      // Hiển thị thông báo lỗi khi tên đăng nhập đã tồn tại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Tên đăng nhập đã tồn tại. Vui lòng chọn tên đăng nhập khác.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Thêm thông tin người dùng mới vào cơ sở dữ liệu
    await _dbHelper.insertAccount(username, password, role: '1');

    // Hiển thị thông báo đăng ký thành công
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng ký thành công'),
          content: Text('Bạn đã đăng ký tài khoản thành công.'),
          actions: [
            TextButton(
              onPressed: () {
                // Chuyển hướng về màn hình chính sau khi đóng thông báo
                Navigator.pop(context); // Đóng thông báo
                Navigator.pop(context); // Đóng màn hình đăng ký
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}
