class Product {
  final int id;
  final String title;
  final double price;

  Product({required this.id, required this.title, required this.price});

  factory Product.fromMap(Map<String, dynamic> map) => Product(
        id: map['id'],
        title: map['title'],
        price: map['price'],
      );
}
