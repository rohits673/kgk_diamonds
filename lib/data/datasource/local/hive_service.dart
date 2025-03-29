import 'package:hive/hive.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';

class HiveService {
  final Box<Diamond> cartBox;

  HiveService(this.cartBox);

  List<Diamond> getCartDiamonds() {
    return cartBox.values.toList();
  }

  void addDiamondToCart(Diamond diamond) {
    cartBox.put(diamond.lotId, diamond);
  }

  void removeDiamondFromCart(String lotId) {
    cartBox.delete(lotId);
  }
}
