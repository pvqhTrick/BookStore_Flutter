class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final double price;
  final String image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
