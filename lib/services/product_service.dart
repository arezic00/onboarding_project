import 'package:logger/logger.dart';
import 'package:onboarding_project/models/product.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/dio_client.dart';
import 'package:onboarding_project/utils/constants.dart';

class ProductService {
  final DioClient _dioClient = getIt();
  final Logger logger = getIt();

  Future<List<Product>> getProducts({
    required String accessToken,
    required int skip,
  }) async {
    try {
      final response = await _dioClient.dioRequest(
          path:
              '/auth/products?limit=${ConfigConstants.productsPageSize}&skip=$skip&select=title,price');

      if (response.statusCode == 200) {
        return (response.data['products'] as List<dynamic>)
            .map((jsonProduct) => Product.fromJson(jsonProduct))
            .toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusMessage}');
      }
    } catch (e) {
      logger.d('Error in getProducts: $e');
      rethrow;
    }
  }
}
