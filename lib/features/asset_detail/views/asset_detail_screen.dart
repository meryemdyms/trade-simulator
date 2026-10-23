import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../mock/models/market_asset.dart';
import '../../../mock/state/demo_app_state.dart';
import '../../alerts/widgets/add_alert_dialog.dart';
import '../widgets/live_trades_view.dart';
import '../widgets/order_book_view.dart';
import '../widgets/price_chart_view.dart';
import '../widgets/price_summary_card.dart';
import '../widgets/virtual_trading_panel.dart';

class AssetDetailScreen extends StatefulWidget {
  final MarketAsset asset;

  const AssetDetailScreen({super.key, required this.asset});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  int _selectedBookTab = 0; // 0: Emir Defteri, 1: Canlı İşlemler

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final currentAsset =
            state.findMarket(widget.asset.symbol) ?? widget.asset;
        final isFav = state.isFavorite(currentAsset.symbol);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${currentAsset.baseAsset}/${currentAsset.quoteAsset}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const DemoBadge(label: 'SPOT L2 DEMO'),
                  ],
                ),
                Text(
                  '${currentAsset.name} / Demo Veri',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              // Price Alarm Button
              IconButton(
                icon: const Icon(Icons.add_alert_outlined, size: 20),
                tooltip: 'Fiyat Alarmı Ekle',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AddAlertDialog(
                      defaultSymbol: currentAsset.symbol,
                      defaultPrice: currentAsset.price,
                    ),
                  );
                },
              ),
              // Favorite Toggle
              IconButton(
                icon: Icon(
                  isFav ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isFav
                      ? const Color(0xFFFFC107)
                      : AppColors.textPrimary,
                  size: 22,
                ),
                onPressed: () => state.toggleFavorite(currentAsset.symbol),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Price Summary Card
                  PriceSummaryCard(asset: currentAsset),
                  const SizedBox(height: 14),

                  // 2. Updated Virtual Trading Terminal (AL/SAT + Market/Limit)
                  VirtualTradingPanel(asset: currentAsset),
                  const SizedBox(height: 14),

                  // 3. Professional Interactive Chart
                  PriceChartView(
                    symbol: currentAsset.symbol,
                    currentPrice: currentAsset.price,
                  ),
                  const SizedBox(height: 14),

                  // 4. Order Book & Live Trades Segment
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Tabs: Emir Defteri / Canlı İşlemler
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLowest,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _bookTab(
                                  label: 'Emir Defteri (Depth)',
                                  isSelected: _selectedBookTab == 0,
                                  onTap: () =>
                                      setState(() => _selectedBookTab = 0),
                                ),
                              ),
                              Expanded(
                                child: _bookTab(
                                  label: 'Canlı İşlemler',
                                  isSelected: _selectedBookTab == 1,
                                  onTap: () =>
                                      setState(() => _selectedBookTab = 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (_selectedBookTab == 0)
                          OrderBookView(
                            currentPrice: currentAsset.price,
                            baseAsset: currentAsset.baseAsset,
                            quoteAsset: currentAsset.quoteAsset,
                          )
                        else
                          LiveTradesView(
                            currentPrice: currentAsset.price,
                            baseAsset: currentAsset.baseAsset,
                            quoteAsset: currentAsset.quoteAsset,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 5. Demo Risk Information Card
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    color: AppColors.surfaceLowest,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.security_outlined,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sıfır Riskli Alıştırma',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Bu sürümde piyasa verileri örnektir. Tüm alım-satım işlemleri sanaldır ve gerçek para kullanılmaz.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bookTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
