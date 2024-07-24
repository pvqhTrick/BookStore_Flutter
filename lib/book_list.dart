import 'package:bookstore/auth_provider.dart';
import 'package:bookstore/edit_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'book.dart';
import 'db_helper.dart';

class BookList extends StatefulWidget {
  final DBHelper dbHelper;

  BookList(this.dbHelper);

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  Future<void> loadBooks() async {
    final List<Book> loadedBooks = await widget.dbHelper.getAllBooks();
    setState(() {
      books = loadedBooks;
    });
  }

  void deleteBook(int bookId) async {
    await widget.dbHelper.deleteBook(bookId);
    setState(() {
      books.removeWhere((book) => book.id == bookId);
    });
  }

  void navigateToEditBook(int bookId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookScreen(
          bookId: bookId,
          dbHelper: widget.dbHelper,
        ),
      ),
    ).then((result) {
      // Sau khi quay lại từ màn hình chỉnh sửa, bạn có thể thực hiện các hành động cần thiết tại đây
      // Ví dụ: load lại danh sách sách
      if (result == true) {
        loadBooks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing:
            16.0, // Khoảng cách giữa các quyển sách theo chiều ngang
        mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng theo chiều dọc
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookItem(
          books[index],
          widget.dbHelper,
          onDelete: deleteBook,
          onEdit: () => navigateToEditBook(books[index].id),
        );
      },
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;
  final DBHelper dbHelper;
  final Function(int) onDelete;
  final VoidCallback? onEdit;

  BookItem(this.book, this.dbHelper, {required this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isAdmin = authProvider.role == 'admin';

    return Container(
      width: 460,
      height: 250,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/${book.image}', height: 180, width: 180),
            Text(
              book.title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('Tác giả: ${book.author}'),
            Text(
              'Mô tả: ${book.description}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text('Giá tiền: ${book.price}00 VNĐ'),
            ElevatedButton(
              onPressed: () => addToCart(book.id),
              child: Text('Thêm vào giỏ hàng'),
            ),
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: onEdit,
                    child: Text('Chỉnh sửa'),
                  ),
                  SizedBox(width: 5),
                  TextButton(
                    onPressed: () => onDelete(book.id),
                    child: Text('Xóa sách'),
                  ),
                ],
              ),
            Divider(),
          ],
        ),
      ),
    );
  }

  void addToCart(int bookId) {
    dbHelper.addToCart(bookId);
  }
}

bool get isAdmin => false; // thêm, sửa và xóa
