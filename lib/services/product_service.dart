import 'package:dio/dio.dart';
import 'package:onboarding_project/models/product.dart';
import 'package:onboarding_project/services/secure_storage_service.dart';

import '../utils/constants.dart';

class ProductService {
  final Dio _dio = Dio();
  final SecureStorageService _storageService = SecureStorageService();

  //TODO: add limit and skip parameters for pagination, select
  Future<List<Product>> getProducts() async {
    try {
      final token = await _storageService.getAccessToken();

      final response = await _dio.get(
        ApiConstants.productsUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
        ),
      );

      //TODO: switch case for status codes 401 Unauthorized (token expired) and 403 Forbidden (invalid token)

      if (response.statusCode == 200) {
        return (response.data['products'] as List<dynamic>)
            .map((jsonProduct) => Product.fromJson(jsonProduct))
            .toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
