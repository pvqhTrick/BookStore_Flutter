import 'package:bookstore/home_page.dart';
import 'package:flutter/material.dart';
import 'book.dart';
import 'db_helper.dart';

class EditBookScreen extends StatefulWidget {
  final int bookId;
  final DBHelper dbHelper;

  EditBookScreen({required this.bookId, required this.dbHelper});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controllers và tải thông tin sách hiện tại
    titleController = TextEditingController();
    authorController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();

    loadBookInfo();
  }

  Future<void> loadBookInfo() async {
    // Lấy thông tin sách từ cơ sở dữ liệu và cập nhật controllers
    final Book book = await widget.dbHelper.getBookById(widget.bookId);
    titleController.text = book.title;
    authorController.text = book.author;
    descriptionController.text = book.description;
    priceController.text = book.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa sách'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Tiêu đề'),
            ),
            TextField(
              controller: authorController,
              decoration: InputDecoration(labelText: 'Tác giả'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Giá tiền'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => updateBook(),
              child: Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }

  void updateBook() async {
    final Book currentBook = await widget.dbHelper.getBookById(widget.bookId);
    // Cập nhật thông tin sách và quay lại màn hình trước đó
    final Book updatedBook = Book(
      id: widget.bookId,
      title: titleController.text,
      author: authorController.text,
      description: descriptionController.text,
      price: double.tryParse(priceController.text) ?? 0.0,
      image: currentBook.image,
    );

    await widget.dbHelper.updateBook(updatedBook);

    // Đóng màn hình chỉnh sửa và quay lại màn hình trước đó
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
