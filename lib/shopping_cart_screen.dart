import 'package:flutter/material.dart';
import 'cart.dart';
import 'book.dart';

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<Book> cartItems = Cart.getCartItems();
  Map<int, int> quantityMap = {}; // Map lưu trữ số lượng của từng sách
  Map<int, double> priceMap = {}; // Map lưu trữ giá tiền của từng sách

  @override
  void initState() {
    super.initState();
    // Khởi tạo số lượng ban đầu từ giỏ hàng
    for (var book in cartItems) {
      quantityMap[book.id] = 1;
      priceMap[book.id] = book.price.toDouble(); // Chuyển giá tiền sang double
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text('Your shopping cart is empty.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      Book book = cartItems[index];
                      int quantity = quantityMap[book.id] ?? 1;
                      double price = priceMap[book.id] ?? book.price;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 100.0,
                              height: 100.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  'assets/images/${book.image}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Price: ${price * quantity}00 VNĐ',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          updateQuantity(book.id, quantity - 1);
                                        },
                                        child: Icon(Icons.remove),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text('$quantity'),
                                      SizedBox(width: 8.0),
                                      ElevatedButton(
                                        onPressed: () {
                                          updateQuantity(book.id, quantity + 1);
                                        },
                                        child: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                removeFromCart(book.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ${total.toStringAsFixed(3)} VNĐ',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          checkout();
                        },
                        child: Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (var book in cartItems) {
      int quantity = quantityMap[book.id] ?? 1;
      double price = priceMap[book.id] ?? book.price;
      total += price * quantity;
    }
    return total;
  }

  void updateQuantity(int bookId, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        quantityMap[bookId] = newQuantity;
      }
    });
  }

  void removeFromCart(int bookId) {
    setState(() {
      Cart.removeFromCart(bookId);
      quantityMap.remove(bookId); // Xóa số lượng khi xóa sách khỏi giỏ hàng
      priceMap.remove(bookId); // Xóa giá tiền khi xóa sách khỏi giỏ hàng
    });
  }

  void checkout() {
    // Perform checkout logic
    Cart.checkout();
    setState(() {
      // Update the UI after checkout
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout successful!'),
      ),
    );
  }
}
