import 'package:flutter/foundation.dart';

import '../fixtures/market_fixture.dart';
import '../models/holding.dart';
import '../models/market_asset.dart';
import '../models/price_alert.dart';
import '../models/virtual_order.dart';

class DemoAppState extends ChangeNotifier {
  // Singleton instance for global access if needed, plus standard ChangeNotifier
  static final DemoAppState _instance = DemoAppState._internal();
  factory DemoAppState() => _instance;

  DemoAppState._internal() {
    _initializeDefaults();
  }

  // --- Base Market Data ---
  final List<MarketAsset> _markets = List.from(mockMarkets);
  List<MarketAsset> get markets => List.unmodifiable(_markets);

  late MarketAsset _selectedAsset;
  MarketAsset get selectedAsset => _selectedAsset;

  // --- Display Settings ---
  String _currencyDisplay = 'TRY'; // 'TRY' or 'USDT'
  String get currencyDisplay => _currencyDisplay;

  // --- Favorites ---
  final Set<String> _favorites = {'BTCUSDT', 'ETHUSDT', 'SOLUSDT'};
  Set<String> get favorites => Set.unmodifiable(_favorites);

  // --- Portfolio Cash & Balances ---
  // Base portfolio calculations are performed in USDT using the fixed demo rate
  late double _availableCashUsdt;
  double _reservedCashUsdt = 0.0;
  double _realizedPnLUsdt = 0.0;

  double get availableCashUsdt => _availableCashUsdt;
  double get reservedCashUsdt => _reservedCashUsdt;
  double get totalCashUsdt => _availableCashUsdt + _reservedCashUsdt;

  double get availableCashTry => _availableCashUsdt * kDemoTryUsdtRate;
  double get totalCashTry => totalCashUsdt * kDemoTryUsdtRate;

  // Holdings Map: symbol -> PortfolioHolding
  final Map<String, PortfolioHolding> _holdings = {};
  Map<String, PortfolioHolding> get holdings => Map.unmodifiable(_holdings);

  // Orders and Trades
  final List<VirtualOrder> _pendingOrders = [];
  List<VirtualOrder> get pendingOrders => List.unmodifiable(_pendingOrders);

  final List<VirtualOrder> _tradeHistory = [];
  List<VirtualOrder> get tradeHistory => List.unmodifiable(_tradeHistory);

  // Price Alerts
  final List<PriceAlert> _priceAlerts = [];
  List<PriceAlert> get priceAlerts => List.unmodifiable(_priceAlerts);

  void _initializeDefaults() {
    _selectedAsset = _markets.first;
    // Initial capital: 100,000 TRY converted to USDT base
    _availableCashUsdt = kDefaultInitialCapitalTry / kDemoTryUsdtRate;
    _reservedCashUsdt = 0.0;
    _realizedPnLUsdt = 0.0;

    _holdings.clear();
    _pendingOrders.clear();
    _tradeHistory.clear();
    _priceAlerts.clear();

    // Default sample price alert
    _priceAlerts.add(
      PriceAlert(
        id: 'alert_1',
        symbol: 'BTCUSDT',
        targetPrice: 70000.0,
        isAbove: true,
        isActive: true,
        createdAt: DateTime.now().millisecondsSinceEpoch - 86400000,
      ),
    );
  }

  // --- Market & Asset Select ---
  void selectAsset(MarketAsset asset) {
    _selectedAsset = asset;
    notifyListeners();
  }

  void selectAssetBySymbol(String symbol) {
    final found = _markets.firstWhere(
      (m) => m.symbol == symbol,
      orElse: () => _markets.first,
    );
    _selectedAsset = found;
    notifyListeners();
  }

  // --- Favorites Management ---
  bool isFavorite(String symbol) => _favorites.contains(symbol);

  void toggleFavorite(String symbol) {
    if (_favorites.contains(symbol)) {
      _favorites.remove(symbol);
    } else {
      _favorites.add(symbol);
    }
    notifyListeners();
  }

  // --- Currency Preference ---
  void setCurrencyDisplay(String currency) {
    if (currency == 'TRY' || currency == 'USDT') {
      _currencyDisplay = currency;
      notifyListeners();
    }
  }

  // --- Portfolio Calculations ---
  MarketAsset? findMarket(String symbol) {
    try {
      return _markets.firstWhere((m) => m.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  double getHoldingCurrentPrice(String symbol) {
    final m = findMarket(symbol);
    return m != null ? m.price : 0.0;
  }

  double get totalHoldingsValueUsdt {
    double total = 0.0;
    for (final holding in _holdings.values) {
      final currentPrice = getHoldingCurrentPrice(holding.symbol);
      total += holding.currentValue(currentPrice);
    }
    return total;
  }

  double get totalPortfolioValueUsdt => totalCashUsdt + totalHoldingsValueUsdt;

  double get totalPortfolioValueInDisplayCurrency {
    if (_currencyDisplay == 'TRY') {
      return totalPortfolioValueUsdt * kDemoTryUsdtRate;
    }
    return totalPortfolioValueUsdt;
  }

  double get availableCashInDisplayCurrency {
    if (_currencyDisplay == 'TRY') {
      return _availableCashUsdt * kDemoTryUsdtRate;
    }
    return _availableCashUsdt;
  }

  double get totalUnrealizedPnLUsdt {
    double total = 0.0;
    for (final holding in _holdings.values) {
      final currentPrice = getHoldingCurrentPrice(holding.symbol);
      total += holding.unrealizedPnL(currentPrice);
    }
    return total;
  }

  double get totalRealizedPnLUsdt => _realizedPnLUsdt;

  double get totalNetPnLUsdt => totalUnrealizedPnLUsdt + _realizedPnLUsdt;

  double get returnPercentage {
    final initialUsdt = kDefaultInitialCapitalTry / kDemoTryUsdtRate;
    if (initialUsdt <= 0) return 0.0;
    return ((totalPortfolioValueUsdt - initialUsdt) / initialUsdt) * 100;
  }

  // Allocation distribution for Donut Chart (BTC, ETH, SOL, Cash, Others)
  List<PortfolioAllocationItem> get allocations {
    final total = totalPortfolioValueUsdt;
    if (total <= 0) {
      return [
        PortfolioAllocationItem(
          label: 'Nakit',
          percentage: 100.0,
          valueUsdt: 0,
        ),
      ];
    }

    final List<PortfolioAllocationItem> items = [];
    double calculatedPercentSum = 0.0;

    for (final holding in _holdings.values) {
      if (holding.quantity > 0) {
        final val = holding.currentValue(
          getHoldingCurrentPrice(holding.symbol),
        );
        final pct = (val / total) * 100;
        if (pct >= 0.5) {
          items.add(
            PortfolioAllocationItem(
              label: holding.baseAsset,
              percentage: pct,
              valueUsdt: val,
            ),
          );
          calculatedPercentSum += pct;
        }
      }
    }

    // Cash allocation
    final cashPct = ((total - totalHoldingsValueUsdt) / total) * 100;
    final normalizedCashPct = (100.0 - calculatedPercentSum).clamp(0.0, 100.0);
    items.add(
      PortfolioAllocationItem(
        label: 'Nakit (USDT)',
        percentage: normalizedCashPct > 0 ? normalizedCashPct : cashPct,
        valueUsdt: totalCashUsdt,
      ),
    );

    return items;
  }

  // --- Virtual Trading Engine ---

  /// Execute instant Market Order
  bool executeMarketOrder({
    required MarketAsset asset,
    required TradeSide side,
    required double quantity,
    required double price,
  }) {
    if (quantity <= 0 || price <= 0) return false;
    final totalCostUsdt = quantity * price;

    if (side == TradeSide.buy) {
      if (_availableCashUsdt < totalCostUsdt) return false;

      // Deduct cash
      _availableCashUsdt -= totalCostUsdt;

      // Update or create holding
      final existing = _holdings[asset.symbol];
      if (existing != null) {
        final newQty = existing.quantity + quantity;
        final newAvgCost =
            ((existing.quantity * existing.averageCost) + totalCostUsdt) /
            newQty;
        _holdings[asset.symbol] = existing.copyWith(
          quantity: newQty,
          averageCost: newAvgCost,
        );
      } else {
        _holdings[asset.symbol] = PortfolioHolding(
          symbol: asset.symbol,
          baseAsset: asset.baseAsset,
          name: asset.name,
          quantity: quantity,
          averageCost: price,
        );
      }
    } else {
      // Sell
      final existing = _holdings[asset.symbol];
      if (existing == null || existing.availableQuantity < quantity) {
        return false;
      }

      // Calculate realized PnL
      final costBasisPortion = quantity * existing.averageCost;
      final saleRevenue = totalCostUsdt;
      _realizedPnLUsdt += (saleRevenue - costBasisPortion);

      // Add cash
      _availableCashUsdt += saleRevenue;

      // Update holding
      final remainingQty = existing.quantity - quantity;
      if (remainingQty <= 0.00000001) {
        _holdings.remove(asset.symbol);
      } else {
        _holdings[asset.symbol] = existing.copyWith(quantity: remainingQty);
      }
    }

    // Record trade in history
    final trade = VirtualOrder(
      id: 'ORD_${DateTime.now().millisecondsSinceEpoch}',
      symbol: asset.symbol,
      baseAsset: asset.baseAsset,
      side: side,
      type: OrderType.market,
      quantity: quantity,
      price: price,
      total: totalCostUsdt,
      status: OrderStatus.filled,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _tradeHistory.insert(0, trade);

    notifyListeners();
    return true;
  }

  /// Create pending Limit Order
  bool createLimitOrder({
    required MarketAsset asset,
    required TradeSide side,
    required double quantity,
    required double limitPrice,
  }) {
    if (quantity <= 0 || limitPrice <= 0) return false;
    final totalCostUsdt = quantity * limitPrice;

    if (side == TradeSide.buy) {
      if (_availableCashUsdt < totalCostUsdt) return false;

      // Reserve cash
      _availableCashUsdt -= totalCostUsdt;
      _reservedCashUsdt += totalCostUsdt;
    } else {
      // Sell
      final existing = _holdings[asset.symbol];
      if (existing == null || existing.availableQuantity < quantity) {
        return false;
      }

      // Reserve holding quantity
      _holdings[asset.symbol] = existing.copyWith(
        reservedQuantity: existing.reservedQuantity + quantity,
      );
    }

    // Add to pending orders list
    final order = VirtualOrder(
      id: 'LMT_${DateTime.now().millisecondsSinceEpoch}',
      symbol: asset.symbol,
      baseAsset: asset.baseAsset,
      side: side,
      type: OrderType.limit,
      quantity: quantity,
      price: limitPrice,
      total: totalCostUsdt,
      status: OrderStatus.pending,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _pendingOrders.insert(0, order);

    notifyListeners();
    return true;
  }

  /// Cancel pending Limit Order and release reserved funds/assets
  bool cancelLimitOrder(String orderId) {
    final index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index == -1) return false;

    final order = _pendingOrders[index];
    if (order.status != OrderStatus.pending) return false;

    if (order.side == TradeSide.buy) {
      // Release reserved cash
      _reservedCashUsdt -= order.total;
      _availableCashUsdt += order.total;
    } else {
      // Release reserved holdings
      final existing = _holdings[order.symbol];
      if (existing != null) {
        _holdings[order.symbol] = existing.copyWith(
          reservedQuantity: (existing.reservedQuantity - order.quantity).clamp(
            0.0,
            double.infinity,
          ),
        );
      }
    }

    _pendingOrders.removeAt(index);

    // Save cancelled record in history
    _tradeHistory.insert(0, order.copyWith(status: OrderStatus.cancelled));

    notifyListeners();
    return true;
  }

  /// Reset virtual portfolio to initial state (100,000 TRY cash, zero positions)
  void resetPortfolio() {
    _availableCashUsdt = kDefaultInitialCapitalTry / kDemoTryUsdtRate;
    _reservedCashUsdt = 0.0;
    _realizedPnLUsdt = 0.0;
    _holdings.clear();
    _pendingOrders.clear();
    _tradeHistory.clear();
    notifyListeners();
  }

  // --- Price Alerts Management ---
  void addPriceAlert({
    required String symbol,
    required double targetPrice,
    required bool isAbove,
  }) {
    final alert = PriceAlert(
      id: 'ALT_${DateTime.now().millisecondsSinceEpoch}',
      symbol: symbol,
      targetPrice: targetPrice,
      isAbove: isAbove,
      isActive: true,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _priceAlerts.insert(0, alert);
    notifyListeners();
  }

  void togglePriceAlert(String alertId) {
    final index = _priceAlerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      final current = _priceAlerts[index];
      _priceAlerts[index] = current.copyWith(isActive: !current.isActive);
      notifyListeners();
    }
  }

  void deletePriceAlert(String alertId) {
    _priceAlerts.removeWhere((a) => a.id == alertId);
    notifyListeners();
  }
}

class PortfolioAllocationItem {
  final String label;
  final double percentage;
  final double valueUsdt;

  const PortfolioAllocationItem({
    required this.label,
    required this.percentage,
    required this.valueUsdt,
  });
}
