import 'package:kgk_diamonds/domain/repository/diamond_repository.dart';

class RemoveFromCart {
  final DiamondRepository repository;

  RemoveFromCart(this.repository);

  void call(String lotId) {
    repository.removeFromCart(lotId);
  }
}
