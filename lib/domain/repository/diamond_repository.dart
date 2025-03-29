import 'package:kgk_diamonds/data/model/diamond_model.dart';

abstract class DiamondRepository {
  List<Diamond> getCartDiamonds();
  void addToCart(Diamond diamond);
  void removeFromCart(String lotId);
}
