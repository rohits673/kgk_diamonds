import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';
import 'package:kgk_diamonds/presentation/widgets/sort_dropdown.dart';

import '../bloc/diamond_bloc.dart';
import '../bloc/diamond_state.dart';
import '../widgets/diamond_card.dart';
import 'cart_page.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _sortByPrice = true;
  bool _sortByCarat = false;
  bool _isAscending = true;

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopBtn = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTopBtn = _scrollController.offset > 300;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: const Text('Diamonds'),
        elevation: 0,
        actions: [
          BlocBuilder<DiamondBloc, DiamondState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 21),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (state.cartDiamonds.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          state.cartDiamonds.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<DiamondBloc, DiamondState>(
                            builder: (context, state) {
                              return Text(
                                '${state.filteredDiamonds.length} diamonds found',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                      SortDropdownWidget(
                        onSortChanged: (sortByPrice) {
                          setState(() {
                            _sortByPrice = sortByPrice;
                            _sortByCarat = !sortByPrice;
                          });
                        },
                        onOrderChanged: (isAscending) {
                          setState(() {
                            _isAscending = isAscending;
                          });
                        },
                        sortByPrice: _sortByPrice,
                        isAscending: _isAscending,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<DiamondBloc, DiamondState>(
                builder: (context, state) {
                  final diamonds = _sortDiamonds(state.filteredDiamonds);

                  if (diamonds.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: 0.785398,
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Diamonds Found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: diamonds.length,
                    itemBuilder: (context, index) {
                      final diamond = diamonds[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: DiamondCard(
                            diamond: diamond,
                            isInCart: state.cartDiamonds.contains(diamond)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTopBtn
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppTheme.primaryColor,
              mini: true,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }

  List<Diamond> _sortDiamonds(List<Diamond> diamonds) {
    final sortedDiamonds = List<Diamond>.from(diamonds);
    if (_sortByPrice) {
      sortedDiamonds.sort((a, b) => _isAscending
          ? a.finalAmount.compareTo(b.finalAmount)
          : b.finalAmount.compareTo(a.finalAmount));
    } else if (_sortByCarat) {
      sortedDiamonds.sort((a, b) => _isAscending
          ? a.carat.compareTo(b.carat)
          : b.carat.compareTo(a.carat));
    }
    return sortedDiamonds;
  }
}
