import 'package:bookstore/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets.dart';
import 'db_helper.dart';
import 'book_list.dart';

class MyHomePage extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isAdmin = authProvider.role == 'admin';
    return Scaffold(
      appBar: AppBarWidget(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách sách',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SearchForm(),
            SizedBox(height: 10),
            if (isAdmin) AddBookButton(),
            Expanded(
              child: BookList(dbHelper),
            ),
          ],
        ),
      ),
    );
  }
}
