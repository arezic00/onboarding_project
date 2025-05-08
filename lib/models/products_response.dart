import 'product.dart';

class ProductsResponse {
  final List<Product> products;
  final int total;

  ProductsResponse({
    required this.products,
    required this.total,
  });

  factory ProductsResponse.fromMap(Map<String, dynamic> map) {
    return ProductsResponse(
      products: (map['products'] as List<dynamic>)
          .map((productMap) => Product.fromMap(productMap))
          .toList(),
      total: map['total'] as int,
    );
  }
}
