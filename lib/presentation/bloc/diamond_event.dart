import 'package:kgk_diamonds/data/model/diamond_model.dart';

abstract class DiamondEvent {}

class LoadCartDiamondsEvent extends DiamondEvent {}

class FilterDiamondsEvent extends DiamondEvent {
  final double? minCarat;
  final double? maxCarat;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  FilterDiamondsEvent({
    this.minCarat,
    this.maxCarat,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });
}

class AddToCartEvent extends DiamondEvent {
  final Diamond diamond;
  AddToCartEvent(this.diamond);
}

class RemoveFromCartEvent extends DiamondEvent {
  final Diamond diamond;
  RemoveFromCartEvent(this.diamond);
}
