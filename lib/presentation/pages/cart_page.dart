import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_bloc.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_state.dart';
import 'package:kgk_diamonds/presentation/widgets/cart_summary.dart';
import 'package:kgk_diamonds/presentation/widgets/diamond_card.dart';
import 'package:kgk_diamonds/presentation/widgets/empty_cart_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isSummaryExpanded = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _isSummaryExpanded.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isSummaryExpanded.value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _isSummaryExpanded.value = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isSummaryExpanded.value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _isSummaryExpanded.value = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        title:
            BlocBuilder<DiamondBloc, DiamondState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Cart',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${state.cartDiamonds.length} diamonds selected',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          );
        }),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child:
            BlocBuilder<DiamondBloc, DiamondState>(builder: (context, state) {
          if (state.cartDiamonds.isEmpty) {
            return const EmptyCartView();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.cartDiamonds.length,
                  itemBuilder: (context, index) {
                    final diamond = state.cartDiamonds[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DiamondCard(
                        diamond: diamond,
                        isInCart: true,
                        showDeleteButton: true,
                        showAddToCartButton: false,
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isSummaryExpanded,
                builder: (context, isExpanded, child) {
                  return CartSummary(
                      isExpanded: isExpanded,
                      state: state,
                      onTap: () {
                        setState(() {
                          _isSummaryExpanded.value = !_isSummaryExpanded.value;
                        });
                      });
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
