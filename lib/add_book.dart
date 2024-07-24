import 'package:bookstore/home_page.dart';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'book.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm sách'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tiêu đề'),
            TextField(controller: titleController),
            SizedBox(height: 10),
            Text('Tác giả'),
            TextField(controller: authorController),
            SizedBox(height: 10),
            Text('Mô tả'),
            TextField(controller: descriptionController),
            SizedBox(height: 10),
            Text('Giá tiền'),
            TextField(controller: priceController),
            SizedBox(height: 10),
            Text('Ảnh'),
            TextField(controller: imageController),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => addBook(),
                  child: Text('Thêm sách vào thư viện.'),
                ),
                SizedBox(width: 16), // Khoảng cách giữa các nút
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Quay lại'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addBook() async {
    // Lấy dữ liệu từ các trường nhập
    final title = titleController.text;
    final author = authorController.text;
    final description = descriptionController.text;
    final price = double.parse(priceController.text);
    final image = imageController.text;

    // Kiểm tra xem tất cả các trường có được nhập đủ không
    if (title.isEmpty ||
        author.isEmpty ||
        description.isEmpty ||
        price.isNaN ||
        image.isEmpty) {
      // Hiển thị thông báo lỗi nếu có trường nào đó không được nhập
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập đầy đủ thông tin sách.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Tạo đối tượng Book từ dữ liệu nhập
    final newBook = Book(
      id: 0,
      title: title,
      author: author,
      description: description,
      price: price,
      image: image,
    );

    // Thêm sách vào cơ sở dữ liệu
    await dbHelper.insertBook(newBook);

    // Hiển thị thông báo thành công và quay về màn hình trước đó
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thành công'),
        content: Text('Đã thêm sách thành công.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );

    // Quay về màn hình trước đó
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(),
      ),
    );
  }
}
