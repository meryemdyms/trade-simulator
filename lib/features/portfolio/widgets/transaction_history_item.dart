import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../mock/models/virtual_order.dart';

class TransactionHistoryItem extends StatelessWidget {
  final VirtualOrder order;

  const TransactionHistoryItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isBuy = order.side == TradeSide.buy;
    final color = isBuy ? AppColors.positive : AppColors.negative;
    final isCancelled = order.status == OrderStatus.cancelled;

    return AppCard(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCancelled
                  ? AppColors.surfaceHigh
                  : color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isCancelled ? 'İPTAL' : (isBuy ? 'ALINDI' : 'SATILDI'),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isCancelled ? AppColors.outline : color,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.symbol} • ${order.type == OrderType.market ? "Piyasa" : "Limit"}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      AppFormatters.formatCurrency(
                        order.total,
                        currency: 'USDT',
                      ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppFormatters.formatCryptoAmount(order.quantity, maxDecimals: 4)} @ ${AppFormatters.formatCurrency(order.price, currency: "USDT")}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      AppFormatters.formatDateTime(order.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
