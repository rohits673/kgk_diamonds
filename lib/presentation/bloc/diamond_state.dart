import 'package:kgk_diamonds/data/model/diamond_model.dart';

class DiamondState {
  final List<Diamond> allDiamonds;
  final List<Diamond> filteredDiamonds;
  final List<Diamond> cartDiamonds;
  final bool isLoading;

  DiamondState({
    required this.allDiamonds,
    this.filteredDiamonds = const [],
    this.cartDiamonds = const [],
    this.isLoading = false,
  });

  DiamondState copyWith({
    List<Diamond>? allDiamonds,
    List<Diamond>? filteredDiamonds,
    List<Diamond>? cartDiamonds,
    bool? isLoading,
  }) {
    return DiamondState(
      allDiamonds: allDiamonds ?? this.allDiamonds,
      filteredDiamonds: filteredDiamonds ?? this.filteredDiamonds,
      cartDiamonds: cartDiamonds ?? this.cartDiamonds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  double get totalCaratWeight =>
      cartDiamonds.fold(0, (sum, diamond) => sum + diamond.carat);

  double get totalPrice =>
      cartDiamonds.fold(0, (sum, diamond) => sum + diamond.finalAmount);

  double get averagePrice =>
      cartDiamonds.isNotEmpty ? totalPrice / cartDiamonds.length : 0;

  double get averageDiscount => cartDiamonds.isNotEmpty
      ? cartDiamonds.fold(0, (sum, diamond) => sum + diamond.discount.toInt()) /
          cartDiamonds.length
      : 0;
}
