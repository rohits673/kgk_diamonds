import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kgk_diamonds/core/theme/app_theme.dart';
import 'package:kgk_diamonds/data/model/diamond_model.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_bloc.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_event.dart';
import 'package:kgk_diamonds/presentation/bloc/diamond_state.dart';

class DiamondCard extends StatelessWidget {
  final Diamond diamond;
  final bool isInCart;
  final bool showDeleteButton;
  final bool showAddToCartButton;

  const DiamondCard({
    super.key,
    required this.diamond,
    required this.isInCart,
    this.showDeleteButton = false,
    this.showAddToCartButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDiamondDetails(context, diamond),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDiamondHeader(context),
              if (showAddToCartButton) const SizedBox(height: 16),
              if (showAddToCartButton) _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiamondHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 8),
                    child: Transform.rotate(
                      angle: 0.785398,
                      child: Container(
                        width: 12,
                        height: 12,
                        color: AppTheme.diamondAccent,
                      ),
                    ),
                  ),
                  Text(
                    '${diamond.shape} ${diamond.carat}ct',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Lot ID: ${diamond.lotId}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSpecItem('Color', diamond.color, context),
                      SizedBox(height: 10),
                      _buildSpecItem('Cut', diamond.cut, context),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSpecItem('Clarity', diamond.clarity, context),
                      SizedBox(height: 10),
                      _buildSpecItem('Lab', diamond.lab, context),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        // Price info
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\₹${diamond.finalAmount.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '\₹${diamond.perCaratRate.toStringAsFixed(0)}/ct',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${diamond.discount.toStringAsFixed(0)}% off',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successColor,
                  ),
            ),
            if (showDeleteButton) ...[
              const SizedBox(height: 8),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppTheme.errorColor,
                  size: 21,
                ),
                onPressed: () {
                  context.read<DiamondBloc>().add(RemoveFromCartEvent(diamond));
                },
                padding: EdgeInsets.all(10),
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (!showAddToCartButton) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => _showDiamondDetails(context, diamond),
          child: const Text('More Details'),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.textSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 36),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final bloc = context.read<DiamondBloc>();
            isInCart
                ? bloc.add(RemoveFromCartEvent(diamond))
                : bloc.add(AddToCartEvent(diamond));
          },
          icon: Icon(
            isInCart ? Icons.remove_circle_outline : Icons.add_circle_outline,
            size: 18,
          ),
          label: Text(isInCart ? 'Remove' : 'Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isInCart
                ? AppTheme.errorColor.withOpacity(0.1)
                : AppTheme.primaryColor.withOpacity(0.1),
            foregroundColor:
                isInCart ? AppTheme.errorColor : AppTheme.primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: isInCart
                    ? AppTheme.errorColor.withOpacity(0.3)
                    : AppTheme.primaryColor.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }

  void _showDiamondDetails(BuildContext context, Diamond diamond) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
              left: 24,
              top: 20,
              right: 24,
              bottom: MediaQuery.of(context).padding.bottom + 10),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Transform.rotate(
                    angle: 0.785398,
                    child: Container(
                      width: 16,
                      height: 16,
                      color: AppTheme.diamondAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${diamond.shape} ${diamond.carat}ct',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(
                          'Basic Information',
                          [
                            _buildDetailRow('Lot ID', diamond.lotId, context),
                            _buildDetailRow('Size', diamond.size, context),
                            _buildDetailRow(
                                'Carat', diamond.carat.toString(), context),
                            _buildDetailRow('Lab', diamond.lab, context),
                            _buildDetailRow('Shape', diamond.shape, context),
                          ],
                          context),
                      _buildDetailSection(
                          'Quality',
                          [
                            _buildDetailRow('Color', diamond.color, context),
                            _buildDetailRow(
                                'Clarity', diamond.clarity, context),
                            _buildDetailRow('Cut', diamond.cut, context),
                            _buildDetailRow('Polish', diamond.polish, context),
                            _buildDetailRow(
                                'Symmetry', diamond.symmetry, context),
                            _buildDetailRow(
                                'Fluorescence', diamond.fluorescence, context),
                          ],
                          context),
                      _buildDetailSection(
                          'Pricing',
                          [
                            _buildDetailRow(
                                'Discount',
                                '${diamond.discount.toStringAsFixed(2)}%',
                                context),
                            _buildDetailRow(
                                'Per Carat Rate',
                                '\₹${diamond.perCaratRate.toStringAsFixed(2)}',
                                context),
                            _buildDetailRow(
                                'Final Amount',
                                '\₹${diamond.finalAmount.toStringAsFixed(2)}',
                                context),
                          ],
                          context),
                      if (diamond.keyToSymbol.isNotEmpty ||
                          diamond.labComment.isNotEmpty)
                        _buildDetailSection(
                            'Additional Information',
                            [
                              if (diamond.keyToSymbol.isNotEmpty)
                                _buildDetailColumn('Key To Symbol',
                                    diamond.keyToSymbol, context),
                              if (diamond.labComment.isNotEmpty)
                                _buildDetailColumn(
                                    'Lab Comment', diamond.labComment, context),
                            ],
                            context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<DiamondBloc, DiamondState>(
                builder: (context, state) {
                  final isInCart = state.cartDiamonds.contains(diamond);
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final bloc = context.read<DiamondBloc>();
                        isInCart
                            ? bloc.add(RemoveFromCartEvent(diamond))
                            : bloc.add(AddToCartEvent(diamond));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart
                            ? AppTheme.errorColor
                            : AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isInCart ? 'Remove from Cart' : 'Add to Cart',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(
      String title, List<Widget> children, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          SizedBox(height: 5),
          Text(
            '- $value',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
