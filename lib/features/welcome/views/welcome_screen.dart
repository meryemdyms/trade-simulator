import 'package:flutter/material.dart';

import '../../../app/navigation/app_shell.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Top Brand & Demo Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.candlestick_chart,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Aether Crypto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const DemoBadge(label: 'SİMÜLASYON'),
                ],
              ),
              const SizedBox(height: 36),

              // Hero Headline
              const Text(
                'Gerçek Piyasa Verisi,\nRisksiz Simülasyon.',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kripto para piyasalarını profesyonel grafikler ve emir defteri ile takip edin, 100.000 TL sanal sermaye ile alıştırma yapın.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Feature Highlights
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    _FeatureTile(
                      icon: Icons.account_balance_wallet_outlined,
                      title: '100.000 TL Sanal Bakiye',
                      description: 'Risk almadan stratejilerinizi test edin.',
                    ),
                    SizedBox(height: 14),
                    _FeatureTile(
                      icon: Icons.stacked_line_chart,
                      title: 'Profesyonel Mum Grafikleri',
                      description: '1S, 1G, 1H, 1A periyotları ve hareketli ortalamalar.',
                    ),
                    SizedBox(height: 14),
                    _FeatureTile(
                      icon: Icons.menu_book_outlined,
                      title: 'Binance Modeli Emir Defteri',
                      description:
                          'Canlı derinlik ve gerçekleşen işlemler penceresi.',
                    ),
                    SizedBox(height: 14),
                    _FeatureTile(
                      icon: Icons.tune,
                      title: 'Market ve Limit Emirleri',
                      description: 'Hem anlık hem hedef fiyatlı emir yönetimi.',
                    ),
                  ],
                ),
              ),

              // CTA Button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AppShell()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Piyasaları Keşfet & Alım-Satıma Başla',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Tamamen simüle edilmiş işlem deneyimi.',
                  style: TextStyle(fontSize: 12, color: AppColors.outline),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
