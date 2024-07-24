import 'package:bookstore/cart.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart';

class DBHelper {
  static Database? _database;

  DBHelper() {}

  Future<void> initDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'bookstore.db'),
        onCreate: (db, version) async {
          // Tạo bảng books
          await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            description TEXT,
            price REAL,
            image TEXT
          )
        ''');

          // Tạo bảng accounts
          await db.execute('''
          CREATE TABLE accounts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            password TEXT,
            role TEXT
          )
        ''');
        },
        version: 1,
      );
    }
  }

  Future<List<Book>> searchBooks(String keyword) async {
    await initDatabase();
    final List<Map<String, dynamic>> books = await _database!.query(
      'books',
      where: 'title LIKE ? OR author LIKE ? OR description LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
    );
    return List.generate(books.length, (index) {
      return Book(
        id: books[index]['id'],
        title: books[index]['title'],
        author: books[index]['author'],
        description: books[index]['description'],
        price: books[index]['price'],
        image: books[index]['image'],
      );
    });
  }

  Future<List<Book>> getAllBooks() async {
    await initDatabase();
    final List<Map<String, dynamic>> books = await _database!.query('books');
    return List.generate(books.length, (index) {
      return Book(
        id: books[index]['id'],
        title: books[index]['title'],
        author: books[index]['author'],
        description: books[index]['description'],
        price: books[index]['price'],
        image: books[index]['image'],
      );
    });
  }

  Future<void> deleteBook(int bookId) async {
    await initDatabase();
    await _database!.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  Future<void> addToCart(int bookId) async {
    Cart.addToCart(bookId);
  }

  Future<void> updateBook(Book book) async {
    await initDatabase();
    await _database!.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> insertBook(Book book) async {
    await initDatabase();
    await _database!.insert(
      'books',
      {
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'price': book.price,
        'image': book.image,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<Book> getBookById(int bookId) async {
    await initDatabase();
    final List<Map<String, dynamic>> books = await _database!.query(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );

    if (books.isNotEmpty) {
      return Book(
        id: books[0]['id'],
        title: books[0]['title'],
        author: books[0]['author'],
        description: books[0]['description'],
        price: books[0]['price'],
        image: books[0]['image'],
      );
    } else {
      // Trả về một đối tượng Book rỗng hoặc xử lý tùy thuộc vào yêu cầu của bạn
      return Book(
          id: 0, title: '', author: '', description: '', price: 0.0, image: '');
    }
  }

  Future<void> dispose() async {
    await _database?.close();
  }

  // Log thông tin quyết định và thông tin debug
  void log(String message) {
    print('[DBHelper] $message');
  }

  Future<void> performDatabaseTransaction(
      Future<void> Function(Transaction txn) action) async {
    await initDatabase();
    await _database!.transaction((txn) async {
      try {
        await action(txn);
      } catch (e) {
        log('Error during transaction: $e');
        rethrow;
      }
    });
  }

  Future<void> insertAccount(String username, String password,
      {String role = ''}) async {
    await initDatabase();
    await _database!.insert(
      'accounts',
      {
        'username': username,
        'password': password,
        'role': role,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<bool> isUsernameExists(String username) async {
    await initDatabase();
    final List<Map<String, dynamic>> result = await _database!.query(
      'accounts',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> validateLogin(
      String username, String password) async {
    await initDatabase();
    final List<Map<String, dynamic>> result = await _database!.query(
      'accounts',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return result[0];
    } else {
      return {};
    }
  }
}
