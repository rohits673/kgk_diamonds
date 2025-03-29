import 'package:kgk_diamonds/domain/repository/diamond_repository.dart';
import 'package:kgk_diamonds/data/datasource/local/hive_service.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';

class DiamondRepositoryImpl implements DiamondRepository {
  final HiveService hiveService;

  DiamondRepositoryImpl(this.hiveService);

  @override
  List<Diamond> getCartDiamonds() => hiveService.getCartDiamonds();

  @override
  void addToCart(Diamond diamond) => hiveService.addDiamondToCart(diamond);

  @override
  void removeFromCart(String lotId) => hiveService.removeDiamondFromCart(lotId);
}
