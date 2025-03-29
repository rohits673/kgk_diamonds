import 'package:kgk_diamonds/domain/repository/diamond_repository.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';

class AddToCart {
  final DiamondRepository repository;

  AddToCart(this.repository);

  void call(Diamond diamond) {
    repository.addToCart(diamond);
  }
}
