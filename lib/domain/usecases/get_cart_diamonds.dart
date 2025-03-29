import 'package:kgk_diamonds/domain/repository/diamond_repository.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';

class GetCartDiamonds {
  final DiamondRepository repository;

  GetCartDiamonds(this.repository);

  List<Diamond> call() {
    return repository.getCartDiamonds();
  }
}
