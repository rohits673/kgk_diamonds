import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kgk_diamonds/data/datasource/local/hive_service.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';
import 'package:kgk_diamonds/data/repository/diamond_repository.dart';
import 'package:kgk_diamonds/domain/repository/diamond_repository.dart';
import 'package:kgk_diamonds/domain/usecases/add_to_cart.dart';
import 'package:kgk_diamonds/domain/usecases/get_cart_diamonds.dart';
import 'package:kgk_diamonds/domain/usecases/remove_from_cart.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DiamondAdapter());
  final cartBox = await Hive.openBox<Diamond>('diamond_cart');

  // Services
  sl.registerSingleton<HiveService>(HiveService(cartBox));

  // Repository
  sl.registerSingleton<DiamondRepository>(
    DiamondRepositoryImpl(sl<HiveService>()),
  );

  // Use Cases
  sl.registerSingleton<GetCartDiamonds>(GetCartDiamonds(sl()));
  sl.registerSingleton<AddToCart>(AddToCart(sl()));
  sl.registerSingleton<RemoveFromCart>(RemoveFromCart(sl()));

  // Bloc
  sl.registerFactory(() => DiamondBloc(sl(), sl(), sl()));
}
