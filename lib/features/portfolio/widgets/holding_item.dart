import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/market_value_text.dart';
import '../../../mock/models/holding.dart';

class HoldingItem extends StatelessWidget {
  final PortfolioHolding holding;
  final double currentPrice;
  final String currencyDisplay;
  final VoidCallback onTap;

  const HoldingItem({
    super.key,
    required this.holding,
    required this.currentPrice,
    required this.currencyDisplay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final curValUsdt = holding.currentValue(currentPrice);
    final curVal = currencyDisplay == 'TRY' ? curValUsdt * 34.50 : curValUsdt;
    final pnlUsdt = holding.unrealizedPnL(currentPrice);
    final pnlDisplay = currencyDisplay == 'TRY' ? pnlUsdt * 34.50 : pnlUsdt;
    final retPct = holding.returnPercentage(currentPrice);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                holding.baseAsset.length > 3
                    ? holding.baseAsset.substring(0, 3)
                    : holding.baseAsset,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      holding.baseAsset,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (holding.reservedQuantity > 0) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bloke: ${AppFormatters.formatCryptoAmount(holding.reservedQuantity, maxDecimals: 4)}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.outline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppFormatters.formatCryptoAmount(holding.quantity, maxDecimals: 6)} ${holding.baseAsset}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Ort: ${AppFormatters.formatCurrency(holding.averageCost, currency: "USDT")}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.formatCurrency(curVal, currency: currencyDisplay),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MarketValueText(
                    value: retPct,
                    isPercentage: true,
                    fontSize: 11,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${pnlDisplay >= 0 ? "+" : ""}${AppFormatters.formatCurrency(pnlDisplay, currency: currencyDisplay, decimals: 0)})',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: pnlDisplay >= 0
                          ? AppColors.positive
                          : AppColors.negative,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
