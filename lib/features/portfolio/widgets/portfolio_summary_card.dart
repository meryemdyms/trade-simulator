import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../core/widgets/market_value_text.dart';
import '../../../mock/state/demo_app_state.dart';

class PortfolioSummaryCard extends StatelessWidget {
  final DemoAppState state;

  const PortfolioSummaryCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currency = state.currencyDisplay;
    final totalVal = state.totalPortfolioValueInDisplayCurrency;
    final availableCash = state.availableCashInDisplayCurrency;
    final returnPct = state.returnPercentage;
    final netPnlUsdt = state.totalNetPnLUsdt;
    final netPnlDisplay = currency == 'TRY' ? netPnlUsdt * 34.50 : netPnlUsdt;

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Sanal Servet',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              DemoBadge(label: 'SİMÜLE SERMAYE'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                AppFormatters.formatCurrency(totalVal, currency: currency),
                style: AppTypography.displayBalance.copyWith(fontSize: 32),
              ),
              const SizedBox(width: 8),
              MarketValueText(
                value: returnPct,
                isPercentage: true,
                fontSize: 13,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            height: 1,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metric(
                'Kullanılabilir Nakit',
                AppFormatters.formatCurrency(availableCash, currency: currency),
              ),
              _metric(
                'Net P/L (Toplam)',
                '${netPnlDisplay >= 0 ? "+" : ""}${AppFormatters.formatCurrency(netPnlDisplay, currency: currency)}',
                valueColor: netPnlDisplay >= 0
                    ? AppColors.positive
                    : AppColors.negative,
              ),
              _metric(
                'Başlangıç',
                currency == 'TRY' ? '100.000 ₺' : '\$2,898.55',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, {Color? valueColor}) {
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
