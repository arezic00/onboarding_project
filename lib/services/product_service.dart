import 'package:onboarding_project/models/product.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/dio_client.dart';

class ProductService {
  final DioClient _dioClient = getIt();

  //TODO: add limit and skip parameters for pagination, select
  Future<List<Product>> getProducts(String accessToken) async {
    try {
      final response = await _dioClient.dioRequest(path: '/auth/products');

      if (response.statusCode == 200) {
        return (response.data['products'] as List<dynamic>)
            .map((jsonProduct) => Product.fromJson(jsonProduct))
            .toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error in getProducts: $e');
      rethrow;
    }
  }
}
