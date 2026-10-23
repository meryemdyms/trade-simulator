import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/market_value_text.dart';
import '../../../mock/models/market_asset.dart';
import 'sparkline_painter.dart';

class MarketListItem extends StatelessWidget {
  final MarketAsset asset;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const MarketListItem({
    super.key,
    required this.asset,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            // Coin Icon
            _CoinAvatar(symbol: asset.baseAsset),
            const SizedBox(width: 12),

            // Symbol & Full Name
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        asset.baseAsset,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '/${asset.quoteAsset}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${asset.name} • ${AppFormatters.formatCompactNumber(asset.quoteVolume)} \$',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Mini 24h Sparkline
            SparklineWidget(
              data: asset.sparkline,
              isPositive: asset.isPositive,
              width: 58,
              height: 24,
            ),
            const SizedBox(width: 8),

            // Price & Change %
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppFormatters.formatCurrency(asset.price, currency: 'USDT'),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: asset.isPositive
                          ? AppColors.positive.withValues(alpha: 0.14)
                          : AppColors.negative.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: MarketValueText(
                      value: asset.change24h,
                      isPercentage: true,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Favorite Icon Button
            IconButton(
              iconSize: 20,
              padding: const EdgeInsets.only(left: 6),
              constraints: const BoxConstraints(),
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFavorite ? const Color(0xFFFFC107) : AppColors.outline,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoinAvatar extends StatelessWidget {
  final String symbol;

  const _CoinAvatar({required this.symbol});

  Color _getSymbolColor(String s) {
    switch (s) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'SOL':
        return const Color(0xFF14F195);
      case 'BNB':
        return const Color(0xFFF3BA2F);
      case 'SUI':
        return const Color(0xFF4DA2FF);
      case 'AVAX':
        return const Color(0xFFE84142);
      case 'XRP':
        return const Color(0xFF23292F);
      case 'ADA':
        return const Color(0xFF0033AD);
      default:
        return AppColors.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _getSymbolColor(symbol);
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bg.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Center(
        child: Text(
          symbol.length > 3 ? symbol.substring(0, 3) : symbol,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: bg.computeLuminance() > 0.5 ? bg : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
