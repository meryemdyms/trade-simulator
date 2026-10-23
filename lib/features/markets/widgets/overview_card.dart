import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/market_value_text.dart';

class MarketOverviewCards extends StatelessWidget {
  final VoidCallback? onGainerTap;

  const MarketOverviewCards({super.key, this.onGainerTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          // 1. Toplam Piyasa Değeri
          SizedBox(
            width: 185,
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.public, size: 14, color: AppColors.primary),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Piyasa Değeri',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '\$2.48T',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Row(
                    children: [
                      MarketValueText(
                        value: 2.34,
                        isPercentage: true,
                        fontSize: 11,
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Giriş \$1.2B',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 2. Günün Parlayanı (Gainer)
          SizedBox(
            width: 185,
            child: AppCard(
              onTap: onGainerTap,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt, size: 14, color: Color(0xFFFFD54F)),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Günün Parlayanı',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SUI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '\$2.14',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const MarketValueText(
                    value: 14.28,
                    isPercentage: true,
                    fontSize: 11,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // 3. Korku & Açgözlülük
          SizedBox(
            width: 185,
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.speed, size: 14, color: AppColors.positive),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Korku & Açgözlülük',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        '68',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.positive,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Açgözlülük',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Dün: 64 (Nötr)',
                    style: TextStyle(fontSize: 10, color: AppColors.outline),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
