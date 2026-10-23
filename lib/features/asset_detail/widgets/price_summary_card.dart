import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/market_value_text.dart';
import '../../../mock/models/market_asset.dart';

class PriceSummaryCard extends StatelessWidget {
  final MarketAsset asset;

  const PriceSummaryCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Spot Gösterge Fiyatı',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: asset.isPositive
                      ? AppColors.positive.withValues(alpha: 0.14)
                      : AppColors.negative.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: MarketValueText(
                  value: asset.change24h,
                  isPercentage: true,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                AppFormatters.formatCurrency(asset.price, currency: 'USDT'),
                style: AppTypography.displayBalance.copyWith(fontSize: 30),
              ),
              const SizedBox(width: 8),
              Text(
                asset.quoteAsset,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(
            height: 1,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: '24s Yüksek',
                value: AppFormatters.formatCurrency(
                  asset.high24h,
                  currency: 'USDT',
                ),
              ),
              _StatItem(
                label: '24s Düşük',
                value: AppFormatters.formatCurrency(
                  asset.low24h,
                  currency: 'USDT',
                ),
              ),
              _StatItem(
                label: '24s Hacim',
                value:
                    '${AppFormatters.formatCompactNumber(asset.volume)} ${asset.baseAsset}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.outline),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
