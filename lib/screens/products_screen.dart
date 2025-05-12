import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_project/cubits/auth_cubit.dart';
import 'package:onboarding_project/cubits/products_cubit.dart';
import 'package:onboarding_project/utils/debouncer.dart';
import 'package:onboarding_project/widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  String get query => _searchController.text.trim();

  @override
  void initState() {
    super.initState();

    final productsCubit = context.read<ProductsCubit>();
    final authState = context.read<AuthCubit>().state;
    if (productsCubit.state is ProductsInitial &&
        authState is AuthAuthenticated) {
      productsCubit.getProducts();
    }

    _searchController.addListener(_onSearchChanged);
  }

  String _lastQuery = '';

  void _onSearchChanged() {
    final currentQuery = query;
    if (currentQuery != _lastQuery) {
      _lastQuery = currentQuery;

      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        _debouncer.run(() =>
            context.read<ProductsCubit>().getProducts(search: currentQuery));
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none),
              filled: true,
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<ProductsCubit, ProductsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ProductsLoaded) {
                return NotificationListener<ScrollEndNotification>(
                  onNotification: (scrollEndNotification) {
                    if (scrollEndNotification.metrics.extentAfter == 0 &&
                        !state.hasReachedEnd) {
                      context
                          .read<ProductsCubit>()
                          .getMoreProducts(search: query);
                    }
                    return true;
                  },
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        (index == state.products.length)
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
          ),
        ),
      ],
    );
  }
}
