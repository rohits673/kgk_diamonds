import 'package:flutter/material.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';

class SortDropdownWidget extends StatefulWidget {
  const SortDropdownWidget({
    super.key,
    required this.onSortChanged,
    required this.onOrderChanged,
    required this.sortByPrice,
    required this.isAscending,
  });

  final Function(bool sortByPrice) onSortChanged;
  final Function(bool isAscending) onOrderChanged;
  final bool sortByPrice;
  final bool isAscending;

  @override
  State<SortDropdownWidget> createState() => _SortDropdownWidgetState();
}

class _SortDropdownWidgetState extends State<SortDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            color: AppTheme.backgroundColor,
            onSelected: (value) {
              if (value == 'price') {
                widget.onSortChanged(true);
              } else if (value == 'carat') {
                widget.onSortChanged(false);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'price',
                child: Text(
                  'Sort by Price',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'carat',
                child: Text(
                  'Sort by Carat',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.sort,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.sortByPrice ? 'Price' : 'Carat',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    widget.isAscending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 16,
                    color: Colors.grey[700],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                widget.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 18,
                color: Colors.grey[700],
              ),
              onPressed: () {
                widget.onOrderChanged(!widget.isAscending);
              },
            ),
          ),
        ],
      ),
    );
  }
}
