// cart.dart
import 'book.dart';
import 'db_helper.dart';

class Cart {
  static List<Book> cartItems = [];

  static Future<void> addToCart(int bookId) async {
    // Assuming you have a method to fetch the Book from the bookId in your DBHelper
    Book book = await DBHelper().getBookById(bookId);
    if (book != null) {
      cartItems.add(book);
    }
  }

  static void removeFromCart(int bookId) {
    // Assuming you have a method to remove a book from the cart
    cartItems.removeWhere((book) => book.id == bookId);
  }

  static List<Book> getCartItems() {
    return cartItems;
  }

  static void clearCart() {
    cartItems.clear();
  }

  static double calculateTotal() {
    double total = 0.0;
    for (Book book in cartItems) {
      total += book.price;
    }
    return total;
  }

  static Future<void> checkout() async {
    // Perform checkout logic, e.g., update database, process payment, etc.
    // Clear the cart after a successful checkout
    clearCart();
  }
}
