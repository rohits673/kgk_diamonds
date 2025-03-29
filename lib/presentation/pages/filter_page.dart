import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/data/datasource/mock/diamond_mock_data.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_bloc.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_event.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_state.dart';
import 'package:kgk_diamonds/presentation/pages/cart_page.dart';
import 'package:kgk_diamonds/presentation/pages/results_page.dart';
import 'package:kgk_diamonds/presentation/widgets/filter_dropdown.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late double _minCarat;
  late double _maxCarat;
  late double _currentMinCarat;
  late double _currentMaxCarat;
  String? _selectedLab;
  String? _selectedShape;
  String? _selectedColor;
  String? _selectedClarity;

  late List<String> _labOptions;
  late List<String> _shapeOptions;
  late List<String> _colorOptions;
  late List<String> _clarityOptions;

  @override
  void initState() {
    super.initState();
    _initializeFilters();
  }

  void _initializeFilters() {
    _minCarat = diamonds.fold(
        double.infinity, (min, d) => d.carat < min ? d.carat : min);
    _maxCarat = diamonds.fold(
        double.negativeInfinity, (max, d) => d.carat > max ? d.carat : max);
    _currentMinCarat = _minCarat;
    _currentMaxCarat = _maxCarat;
    _labOptions = diamonds.map((d) => d.lab).toSet().toList();
    _shapeOptions = diamonds.map((d) => d.shape).toSet().toList();
    _colorOptions = diamonds.map((d) => d.color).toSet().toList();
    _clarityOptions = diamonds.map((d) => d.clarity).toSet().toList();
  }

  void _resetFilters() {
    setState(() {
      _initializeFilters();
      _selectedLab = null;
      _selectedShape = null;
      _selectedColor = null;
      _selectedClarity = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Diamonds'),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          BlocBuilder<DiamondBloc, DiamondState>(
            builder: (context, state) {
              return Stack(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(right: 10),
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ),
                      );
                    },
                  ),
                  if (state.cartDiamonds.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          state.cartDiamonds.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carat Range',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_minCarat.toStringAsFixed(2)} - ${_maxCarat.toStringAsFixed(2)} ct',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                          ),
                          const SizedBox(height: 16),
                          RangeSlider(
                            values: RangeValues(_minCarat, _maxCarat),
                            min: _currentMinCarat,
                            max: _currentMaxCarat,
                            activeColor: AppTheme.primaryColor,
                            inactiveColor: Colors.grey.withOpacity(0.2),
                            labels: RangeLabels(
                              _minCarat.toStringAsFixed(2),
                              _maxCarat.toStringAsFixed(2),
                            ),
                            onChanged: (RangeValues values) {
                              setState(() {
                                _minCarat = values.start;
                                _maxCarat = values.end;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilterDropdown(
                    label: 'Lab',
                    value: _selectedLab,
                    options: _labOptions,
                    onChanged: (value) {
                      if (_selectedLab != value) {
                        setState(() {
                          _selectedLab = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FilterDropdown(
                    label: 'Shape',
                    value: _selectedShape,
                    options: _shapeOptions,
                    onChanged: (value) {
                      if (_selectedShape != value) {
                        setState(() {
                          _selectedShape = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FilterDropdown(
                    label: 'Color',
                    value: _selectedColor,
                    options: _colorOptions,
                    onChanged: (value) {
                      if (_selectedColor != value) {
                        setState(() {
                          _selectedColor = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  FilterDropdown(
                    label: 'Clarity',
                    value: _selectedClarity,
                    options: _clarityOptions,
                    onChanged: (value) {
                      if (_selectedClarity != value) {
                        setState(() {
                          _selectedClarity = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _resetFilters,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppTheme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Reset Filters',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<DiamondBloc>().add(
                                FilterDiamondsEvent(
                                  minCarat: _minCarat,
                                  maxCarat: _maxCarat,
                                  lab: _selectedLab,
                                  shape: _selectedShape,
                                  color: _selectedColor,
                                  clarity: _selectedClarity,
                                ),
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResultsPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Search',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
