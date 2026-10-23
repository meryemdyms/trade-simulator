import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../mock/models/price_alert.dart';

class AlertItemCard extends StatelessWidget {
  final PriceAlert alert;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const AlertItemCard({
    super.key,
    required this.alert,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: alert.isActive
                  ? AppColors.primaryContainer.withValues(alpha: 0.2)
                  : AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              alert.isAbove
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: alert.isActive ? AppColors.primary : AppColors.outline,
              size: 20,
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
                      alert.symbol,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: alert.isActive
                            ? AppColors.textPrimary
                            : AppColors.outline,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      alert.isAbove ? '≥ Üstüne çıkınca' : '≤ Altına inince',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Hedef: ${AppFormatters.formatCurrency(alert.targetPrice, currency: "USDT")}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: alert.isActive
                        ? AppColors.textPrimary
                        : AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: alert.isActive,
            activeTrackColor: AppColors.primaryContainer,
            activeThumbColor: Colors.white,
            onChanged: (_) => onToggle(),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
              color: AppColors.outline,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
