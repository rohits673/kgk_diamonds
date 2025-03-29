import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/core/di/dependencies.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_bloc.dart';
import 'package:kgk_diamonds/presentation/pages/filter_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const DiamondSelectionApp());
}

class DiamondSelectionApp extends StatelessWidget {
  const DiamondSelectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DiamondBloc>(),
      child: MaterialApp(
        title: 'Diamond Selection',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.system,
        home: const FilterPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
