import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../mock/models/market_asset.dart';
import '../../../mock/state/demo_app_state.dart';
import '../../alerts/views/alerts_screen.dart';
import '../../asset_detail/views/asset_detail_screen.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/market_list_item.dart';
import '../widgets/overview_card.dart';

class MarketsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToPortfolio;

  const MarketsScreen({super.key, this.onNavigateToPortfolio});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  final TextEditingController _searchController = TextEditingController();
  MarketFilter _selectedFilter = MarketFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MarketAsset> _filterMarkets(DemoAppState state) {
    var list = List<MarketAsset>.from(state.markets);

    // Apply Filter Chips
    switch (_selectedFilter) {
      case MarketFilter.all:
        break;
      case MarketFilter.gainers:
        list = list.where((m) => m.change24h > 0).toList()
          ..sort((a, b) => b.change24h.compareTo(a.change24h));
        break;
      case MarketFilter.losers:
        list = list.where((m) => m.change24h < 0).toList()
          ..sort((a, b) => a.change24h.compareTo(b.change24h));
        break;
      case MarketFilter.highVolume:
        list.sort((a, b) => b.quoteVolume.compareTo(a.quoteVolume));
        break;
      case MarketFilter.favorites:
        list = list.where((m) => state.isFavorite(m.symbol)).toList();
        break;
    }

    // Apply Search Query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((m) {
        return m.symbol.toLowerCase().contains(query) ||
            m.name.toLowerCase().contains(query) ||
            m.baseAsset.toLowerCase().contains(query);
      }).toList();
    }

    return list;
  }

  void _navigateToDetail(MarketAsset asset) {
    DemoAppState().selectAsset(asset);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AssetDetailScreen(asset: asset)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final filteredList = _filterMarkets(state);

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
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aether Markets',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                DemoBadge(label: 'DEMO PİYASA VERİSİ'),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.notifications_none_rounded,
                                color: AppColors.textPrimary,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AlertsScreen(),
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

                // 2. Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Kripto ara (BTC, Ethereum, vb.)...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.outline,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // 3. Overview Cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: MarketOverviewCards(
                      onGainerTap: () {
                        final sui = state.findMarket('SUIUSDT');
                        if (sui != null) _navigateToDetail(sui);
                      },
                    ),
                  ),
                ),

                // 4. Portfolio Quick Access Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      color: AppColors.surfaceLow,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    size: 15,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Sanal Portföy Bakiye',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppFormatters.formatCurrency(
                                  state.totalPortfolioValueInDisplayCurrency,
                                  currency: state.currencyDisplay,
                                ),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            onPressed: widget.onNavigateToPortfolio,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                color: AppColors.primaryContainer,
                                width: 0.8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 15,
                            ),
                            label: const Text(
                              'Portföye Git',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 5. Filter Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FilterChipsRow(
                      selectedFilter: _selectedFilter,
                      onSelected: (filter) {
                        setState(() => _selectedFilter = filter);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // 6. Column Headers
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Varlık / Hacim',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 58,
                          child: Center(
                            child: Text(
                              '24s',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.outline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Fiyat / Değişim',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.outline,
                            ),
                          ),
                        ),
                        SizedBox(width: 26),
                      ],
                    ),
                  ),
                ),

                // 7. Market List
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.outline.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Aradığınız kripto para bulunamadı.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(
                                () => _selectedFilter = MarketFilter.all,
                              );
                            },
                            child: const Text('Filtreleri Temizle'),
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
                        final asset = filteredList[index];
                        final isFav = state.isFavorite(asset.symbol);

                        return MarketListItem(
                          asset: asset,
                          isFavorite: isFav,
                          onTap: () => _navigateToDetail(asset),
                          onFavoriteToggle: () =>
                              state.toggleFavorite(asset.symbol),
                        );
                      }, childCount: filteredList.length),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          ),
        );
      },
    );
  }
}
