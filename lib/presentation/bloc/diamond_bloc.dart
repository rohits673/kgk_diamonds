import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';
import 'package:kgk_diamonds/domain/usecases/add_to_cart.dart';
import 'package:kgk_diamonds/domain/usecases/remove_from_cart.dart';
import 'package:kgk_diamonds/domain/usecases/get_cart_diamonds.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_event.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_state.dart';
import 'package:kgk_diamonds/data/datasource/mock/diamond_mock_data.dart';

class DiamondBloc extends Bloc<DiamondEvent, DiamondState> {
  final GetCartDiamonds getCartDiamonds;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;

  DiamondBloc(
    this.getCartDiamonds,
    this.addToCart,
    this.removeFromCart,
  ) : super(DiamondState(allDiamonds: diamonds, cartDiamonds: [])) {
    on<LoadCartDiamondsEvent>(_onLoadCartDiamonds);
    on<FilterDiamondsEvent>(_onFilterDiamonds);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);

    add(LoadCartDiamondsEvent());
  }

  void _onLoadCartDiamonds(
      LoadCartDiamondsEvent event, Emitter<DiamondState> emit) {
    final cartItems = getCartDiamonds();
    emit(state.copyWith(cartDiamonds: cartItems));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<DiamondState> emit) {
    if (!state.cartDiamonds.any((d) => d.lotId == event.diamond.lotId)) {
      addToCart(event.diamond);
      add(LoadCartDiamondsEvent());
    }
  }

  void _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<DiamondState> emit) {
    removeFromCart(event.diamond.lotId);
    add(LoadCartDiamondsEvent());
  }

  void _onFilterDiamonds(
      FilterDiamondsEvent event, Emitter<DiamondState> emit) {
    List<Diamond> filteredList = state.allDiamonds;

    final hasFilters = event.minCarat != null ||
        event.maxCarat != null ||
        event.lab != null ||
        event.shape != null ||
        event.color != null ||
        event.clarity != null;

    if (hasFilters) {
      filteredList = filteredList
          .where((d) => event.minCarat == null || d.carat >= event.minCarat!)
          .where((d) => event.maxCarat == null || d.carat <= event.maxCarat!)
          .where((d) => event.lab == null || d.lab == event.lab)
          .where((d) => event.shape == null || d.shape == event.shape)
          .where((d) => event.color == null || d.color == event.color)
          .where((d) => event.clarity == null || d.clarity == event.clarity)
          .toList();
    }

    emit(state.copyWith(filteredDiamonds: filteredList));
  }
}
