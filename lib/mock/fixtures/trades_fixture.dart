import '../models/market_trade.dart';

abstract final class MockTradesFixture {
  static List<MarketTrade> getRecentTrades(double currentPrice) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final scale = currentPrice > 1000 ? 1.0 : 100.0;
    final List<MarketTrade> trades = [];

    final deltas = [
      0.0,
      -0.0001,
      0.0002,
      -0.0003,
      0.0001,
      -0.0002,
      0.0003,
      0.0,
      -0.0001,
      0.0002,
    ];
    final qtys = [0.15, 0.42, 0.08, 1.25, 0.33, 0.65, 0.19, 0.84, 0.50, 0.22];
    final directions = [
      false,
      true,
      false,
      false,
      true,
      true,
      false,
      true,
      false,
      true,
    ];

    for (int i = 0; i < deltas.length; i++) {
      final p = currentPrice * (1.0 + deltas[i]);
      trades.add(
        MarketTrade(
          id: 100020 + i,
          price: p,
          quantity: qtys[i] * scale,
          time: now - (i * 3500),
          isBuyerMaker: directions[i],
        ),
      );
    }

    return trades;
  }
}
