import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../mock/fixtures/trades_fixture.dart';

class LiveTradesView extends StatelessWidget {
  final double currentPrice;
  final String baseAsset;
  final String quoteAsset;

  const LiveTradesView({
    super.key,
    required this.currentPrice,
    required this.baseAsset,
    required this.quoteAsset,
  });

  @override
  Widget build(BuildContext context) {
    final trades = MockTradesFixture.getRecentTrades(currentPrice);

    return Column(
      children: [
        // Table Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Saat',
                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Yön',
                  style: TextStyle(fontSize: 11, color: AppColors.outline),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Fiyat ($quoteAsset)',
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
                  'Miktar ($baseAsset)',
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

        // Trade Rows
        ...trades.map((trade) {
          final isBuy = trade.isBuy;
          final color = isBuy ? AppColors.positive : AppColors.negative;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    AppFormatters.formatTime(trade.time),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    isBuy ? 'AL' : 'SAT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    AppFormatters.formatNumber(
                      trade.price,
                      minDecimals: 2,
                      maxDecimals: 2,
                    ),
                    textAlign: TextAlign.end,
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
                      trade.quantity,
                      maxDecimals: 4,
                    ),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
