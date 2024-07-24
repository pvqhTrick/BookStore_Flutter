import 'package:flutter/material.dart';
import 'home_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookstore App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: MyAppBar(),
        body: MyHomePage(),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Bookstore App'),
      actions: [
        AddBookButton(), // Đảm bảo rằng AddBookButton được định nghĩa ở đây
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class AddBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Chuyển hướng đến màn hình thêm sách
        Navigator.pushNamed(context, '/addBook');
      },
      child: Text('Thêm sách'),
    );
  }
}
