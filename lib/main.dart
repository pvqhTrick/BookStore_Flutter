import 'package:bookstore/auth_provider.dart';
import 'package:bookstore/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:provider/provider.dart';
import 'add_book.dart';
import 'register.dart';
import 'login.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/addBook': (context) => AddBookScreen(),
        '/register': (context) => RegisterScreen(),
        '/login': (context) => LoginScreen(
              onLogin: (username, role) {
                // Xử lý sau khi đăng nhập
              },
            ),
        '/home': (context) => MyHomePage(),
        // Các routes khác
      },
      title: 'Bookstore App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
