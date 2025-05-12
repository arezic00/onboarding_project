import 'package:onboarding_project/cubits/base_cubit.dart';
import 'package:onboarding_project/models/product.dart';
import 'package:onboarding_project/models/products_response.dart';
import 'package:onboarding_project/services/product_service.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final int total;
  ProductsLoaded({required this.products, required this.total});

  bool get hasReachedEnd => products.length >= total;

  factory ProductsLoaded.fromResponse(ProductsResponse productResponse) =>
      ProductsLoaded(
          products: productResponse.products, total: productResponse.total);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsCubit extends BaseCubit<ProductsState> {
  final ProductService _productService = ProductService();
  ProductsCubit() : super(ProductsInitial());

  Future<void> getProducts(
      {required String accessToken, String search = ''}) async {
    emit(ProductsLoading());

    try {
      final productsResponse = await _productService.getProducts(
          accessToken: accessToken, skip: 0, search: search);
      safeEmit(ProductsLoaded.fromResponse(productsResponse));
    } catch (e) {
      safeEmit(ProductsError('$e'));
    }
  }

  Future<void> getMoreProducts(
      {required String accessToken, String search = ''}) async {
    if (state is ProductsLoaded) {
      try {
        final loadedState = state as ProductsLoaded;
        final products = loadedState.products;
        final newProductsResponse = await _productService.getProducts(
            accessToken: accessToken, skip: products.length, search: search);
        safeEmit(ProductsLoaded(
            products: [...products, ...newProductsResponse.products],
            total: newProductsResponse.total));
      } catch (e) {
        safeEmit(ProductsError('$e'));
      }
    }
  }
}
