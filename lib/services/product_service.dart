import 'package:logger/logger.dart';
import 'package:onboarding_project/models/products_response.dart';
import 'package:onboarding_project/service_locator.dart';
import 'package:onboarding_project/services/dio_client.dart';
import 'package:onboarding_project/utils/constants.dart';

class ProductService {
  final DioClient _dioClient = getIt();
  final Logger logger = getIt();

  Future<ProductsResponse> getProducts({
    required int skip,
    String search = '',
  }) async {
    try {
      final response = await _dioClient.dioRequest(
          path:
              '/auth/products/search?q=$search&limit=${ConfigConstants.productsPageSize}&skip=$skip&select=title,price');

      if (response.statusCode == 200) {
        return ProductsResponse.fromMap(response.data);
      } else {
        throw Exception('Failed to fetch products: ${response.statusMessage}');
      }
    } catch (e) {
      logger.d('Error in getProducts: $e');
      rethrow;
    }
  }
}
