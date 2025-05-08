import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsCubit = context.read<ProductsCubit>();
    final authState = context.read<AuthCubit>().state;
    if (productsCubit.state is ProductsInitial &&
        authState is AuthAuthenticated) {
      productsCubit.getProducts(authState.authData.accessToken);
    }

    return BlocConsumer<ProductsCubit, ProductsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ProductsLoaded) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEndNotification) {
              if (scrollEndNotification.metrics.extentAfter == 0 &&
                  !state.hasReachedEnd) {
                productsCubit.getMoreProducts(
                    (authState as AuthAuthenticated).authData.accessToken);
              }
              return true;
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => (index == state.products.length)
                  ? Center(
                      child: state.hasReachedEnd
                          ? const Text('No more products.')
                          : const CircularProgressIndicator())
                  : ProductCard(
                      title: state.products[index].title,
                      price: '${state.products[index].price}\$',
                    ),
              itemCount: state.products.length + 1,
            ),
          );
        } else if (state is ProductsError) {
          return const Center(
            child: Text('Couldn\'t load products'),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
