import 'package:flutter/material.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_state.dart';

class CartSummary extends StatelessWidget {
  final bool isExpanded;
  final DiamondState state;
  final Function() onTap;

  const CartSummary(
      {super.key,
      required this.isExpanded,
      required this.state,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Container(
          padding: EdgeInsets.only(
              left: 20,
              top: 16,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, -3),
              )
            ],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Row(
                      children: [
                        Text(
                          '\₹${state.totalPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                _buildSummaryItem(
                    context, 'Items', state.cartDiamonds.length.toString()),
                _buildSummaryItem(context, 'Total Carat Weight',
                    '${state.totalCaratWeight.toStringAsFixed(2)} ct'),
                _buildSummaryItem(context, 'Subtotal',
                    '\₹${state.totalPrice.toStringAsFixed(2)}'),
                _buildSummaryItem(context, 'Average Discount',
                    '${state.averageDiscount.toStringAsFixed(1)}%',
                    isHighlighted: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Proceed to Checkout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String label, String value,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isHighlighted
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted
                    ? AppTheme.primaryColor
                    : AppTheme.textPrimary,
              ),
        ),
      ],
    );
  }
}
