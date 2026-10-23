import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../mock/fixtures/order_book_fixture.dart';
import '../../../mock/models/order_book_level.dart';

class OrderBookView extends StatelessWidget {
  final double currentPrice;
  final String baseAsset;
  final String quoteAsset;

  const OrderBookView({
    super.key,
    required this.currentPrice,
    required this.baseAsset,
    required this.quoteAsset,
  });

  @override
  Widget build(BuildContext context) {
    final snapshot = MockOrderBookFixture.getOrderBook(currentPrice);

    return Column(
      children: [
        // Table Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Fiyat ($quoteAsset)',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Miktar ($baseAsset)',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Toplam ($baseAsset)',
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Asks (Sellers - Red) in reverse so lowest ask is near the center
        ...snapshot.asks
            .take(5)
            .toList()
            .reversed
            .map(
              (ask) => _OrderBookRow(
                level: ask,
                maxQuantity: snapshot.maxQuantity,
                isAsk: true,
              ),
            ),

        // Center: Spread & Current Price
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.arrow_upward_rounded,
                    size: 16,
                    color: AppColors.positive,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppFormatters.formatCurrency(
                      currentPrice,
                      currency: quoteAsset,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.positive,
                    ),
                  ),
                ],
              ),
              Text(
                'Fark (Spread): ${AppFormatters.formatNumber(snapshot.spread, minDecimals: 2, maxDecimals: 2)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Bids (Buyers - Green)
        ...snapshot.bids
            .take(5)
            .map(
              (bid) => _OrderBookRow(
                level: bid,
                maxQuantity: snapshot.maxQuantity,
                isAsk: false,
              ),
            ),
      ],
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  final OrderBookLevel level;
  final double maxQuantity;
  final bool isAsk;

  const _OrderBookRow({
    required this.level,
    required this.maxQuantity,
    required this.isAsk,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAsk ? AppColors.negative : AppColors.positive;
    final depthRatio = maxQuantity > 0
        ? (level.quantity / maxQuantity).clamp(0.05, 1.0)
        : 0.1;

    return Stack(
      children: [
        // Depth background bar aligned to the right
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: depthRatio,
              child: Container(color: color.withValues(alpha: 0.12)),
            ),
          ),
        ),

        // Text Values
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  AppFormatters.formatNumber(
                    level.price,
                    minDecimals: 2,
                    maxDecimals: 2,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  AppFormatters.formatCryptoAmount(
                    level.quantity,
                    maxDecimals: 4,
                  ),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  AppFormatters.formatCryptoAmount(level.total, maxDecimals: 4),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
