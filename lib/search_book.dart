import 'package:bookstore/book.dart';
import 'package:bookstore/db_helper.dart';
import 'package:flutter/material.dart';

class SearchBookScreen extends StatefulWidget {
  final String? query;

  SearchBookScreen({this.query});

  @override
  _SearchBookScreenState createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Book> searchResults = [];

  @override
  void initState() {
    super.initState();
    if (widget.query != null && widget.query!.isNotEmpty) {
      performSearch(widget.query!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm sách'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kết quả tìm kiếm cho "${widget.query}"'),
            SizedBox(height: 10),
            Expanded(
              child: searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchResults[index].title),
                          subtitle: Text(searchResults[index].author),
                          // Add more details or customize as needed
                        );
                      },
                    )
                  : Center(
                      child: Text('Không tìm thấy kết quả'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void performSearch(String keyword) async {
    if (keyword.isNotEmpty) {
      List<Book> results = await dbHelper.searchBooks(keyword);
      setState(() {
        searchResults = results;
      });
    }
  }
}
