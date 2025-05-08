import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/models/product.dart';
import 'package:onboarding_project/services/product_service.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  ProductsLoaded({required this.products});
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsCubit extends Cubit<ProductsState> {
  final ProductService _productService = ProductService();
  ProductsCubit() : super(ProductsInitial());

  Future<void> getProducts(String accessToken) async {
    emit(ProductsLoading());

    try {
      final products =
          await _productService.getProducts(accessToken: accessToken, skip: 0);
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError('$e'));
    }
  }

  Future<void> getMoreProducts(String accessToken) async {
    if (state is ProductsLoaded) {
      try {
        final products = (state as ProductsLoaded).products;
        final newProducts = await _productService.getProducts(
            accessToken: accessToken, skip: products.length);
        emit(ProductsLoaded(products: [...products, ...newProducts]));
      } catch (e) {
        emit(ProductsError('$e'));
      }
    }
  }
}
