import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../mock/state/demo_app_state.dart';
import '../../alerts/views/alerts_screen.dart';
import '../../asset_detail/views/asset_detail_screen.dart';
import '../widgets/allocation_chart.dart';
import '../widgets/holding_item.dart';
import '../widgets/pending_order_item.dart';
import '../widgets/portfolio_summary_card.dart';
import '../widgets/reset_portfolio_dialog.dart';
import '../widgets/transaction_history_item.dart';

class PortfolioScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMarkets;

  const PortfolioScreen({super.key, this.onNavigateToMarkets});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  int _selectedTab = 0; // 0: Varlıklarım, 1: Bekleyen Emirler, 2: İşlem Geçmişi, 3: İstatistikler

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final holdingsList = state.holdings.values
            .where((h) => h.quantity > 0)
            .toList();
        final pendingOrders = state.pendingOrders;
        final history = state.tradeHistory;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aether Portfolio',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [DemoBadge(label: 'SİMÜLASYON MODU')],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: AppColors.outline,
                              ),
                              tooltip: 'Portföyü Sıfırla',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) =>
                                      const ResetPortfolioDialog(),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const AlertsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Summary Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                    child: PortfolioSummaryCard(state: state),
                  ),
                ),

                // 3. Asset Allocation Donut Chart
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: AllocationChart(
                      items: state.allocations,
                      currency: state.currencyDisplay,
                    ),
                  ),
                ),

                // 4. Section Segmented Selector Tabs
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          _tabButton(
                            'Varlıklar',
                            0,
                            count: holdingsList.length,
                          ),
                          _tabButton(
                            'Bekleyen',
                            1,
                            count: pendingOrders.length,
                          ),
                          _tabButton('Geçmiş', 2, count: history.length),
                          _tabButton('İstatistik', 3),
                        ],
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // 5. Tab Content
                if (_selectedTab == 0) ...[
                  // Holdings
                  if (holdingsList.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pie_chart_outline,
                              size: 46,
                              color: AppColors.outline,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Henüz bir kripto varlığınız bulunmuyor.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: widget.onNavigateToMarkets,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryContainer,
                                minimumSize: const Size(180, 42),
                              ),
                              child: const Text('Piyasalardan Alış Yap'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final holding = holdingsList[index];
                          final curPrice = state.getHoldingCurrentPrice(
                            holding.symbol,
                          );

                          return HoldingItem(
                            holding: holding,
                            currentPrice: curPrice,
                            currencyDisplay: state.currencyDisplay,
                            onTap: () {
                              final market = state.findMarket(holding.symbol);
                              if (market != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        AssetDetailScreen(asset: market),
                                  ),
                                );
                              }
                            },
                          );
                        }, childCount: holdingsList.length),
                      ),
                    ),
                ] else if (_selectedTab == 1) ...[
                  // Pending Orders
                  if (pendingOrders.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Bekleyen limit emri bulunmuyor.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final order = pendingOrders[index];
                          return PendingOrderItem(
                            order: order,
                            onCancel: () {
                              state.cancelLimitOrder(order.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.surfaceHigh,
                                  content: Text(
                                    '${order.symbol} limit emri iptal edildi ve bloke serbest bırakıldı.',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        }, childCount: pendingOrders.length),
                      ),
                    ),
                ] else if (_selectedTab == 2) ...[
                  // Trade History
                  if (history.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Henüz gerçekleşmiş bir işlem yok.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final trade = history[index];
                          return TransactionHistoryItem(order: trade);
                        }, childCount: history.length),
                      ),
                    ),
                ] else if (_selectedTab == 3) ...[
                  // Performance Statistics
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _PerformanceStatsCard(state: state),
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tabButton(String label, int index, {int? count}) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surfaceHigh : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 0.8)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              if (count != null && count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PerformanceStatsCard extends StatelessWidget {
  final DemoAppState state;

  const _PerformanceStatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalTrades = state.tradeHistory.length;
    final currency = state.currencyDisplay;
    final rate = currency == 'TRY' ? 34.50 : 1.0;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Demo Performans İstatistikleri',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _statRow('Toplam Simüle İşlem', totalTrades.toString()),
          const Divider(
            height: 16,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          _statRow(
            'Gerçekleşmiş Kâr/Zarar',
            AppFormatters.formatCurrency(
              state.totalRealizedPnLUsdt * rate,
              currency: currency,
            ),
            valueColor: state.totalRealizedPnLUsdt >= 0
                ? AppColors.positive
                : AppColors.negative,
          ),
          const Divider(
            height: 16,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          _statRow(
            'Gerçekleşmemiş Kâr/Zarar',
            AppFormatters.formatCurrency(
              state.totalUnrealizedPnLUsdt * rate,
              currency: currency,
            ),
            valueColor: state.totalUnrealizedPnLUsdt >= 0
                ? AppColors.positive
                : AppColors.negative,
          ),
          const Divider(
            height: 16,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          _statRow(
            'Sanal Getiri Oranı',
            AppFormatters.formatPercentage(state.returnPercentage),
            valueColor: state.returnPercentage >= 0
                ? AppColors.positive
                : AppColors.negative,
          ),
          const Divider(
            height: 16,
            color: AppColors.outlineVariant,
            thickness: 0.5,
          ),
          _statRow(
            'Aktif Bekleyen Emirler',
            state.pendingOrders.length.toString(),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
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
