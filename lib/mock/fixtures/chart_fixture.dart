import '../models/candle.dart';

abstract final class MockChartFixture {
  /// Generate realistic mock candle series based on symbol base price and timeframe
  static List<Candle> getCandles(String symbol, String period) {
    double basePrice = 67840.50;
    if (symbol.startsWith('ETH')) basePrice = 3520.10;
    if (symbol.startsWith('SOL')) basePrice = 184.25;
    if (symbol.startsWith('BNB')) basePrice = 588.60;
    if (symbol.startsWith('SUI')) basePrice = 2.14;
    if (symbol.startsWith('AVAX')) basePrice = 28.45;
    if (symbol.startsWith('XRP')) basePrice = 0.548;
    if (symbol.startsWith('ADA')) basePrice = 0.362;

    int count = 30;
    int intervalMs = 60 * 1000; // 1m for 1H
    if (period == '1G') {
      count = 24;
      intervalMs = 60 * 60 * 1000;
    } else if (period == '1H') {
      count = 28;
      intervalMs = 6 * 60 * 60 * 1000;
    } else if (period == '1A') {
      count = 30;
      intervalMs = 24 * 60 * 60 * 1000;
    } else if (period == 'Tümü') {
      count = 35;
      intervalMs = 3 * 24 * 60 * 60 * 1000;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final List<Candle> candles = [];

    // Deterministic pseudo-random variation based on period and index
    double current = basePrice * 0.96;
    for (int i = 0; i < count; i++) {
      final t = now - (count - i) * intervalMs;
      // Sinusoidal trend + stepped variation
      final trend = (i % 5 == 0 ? -1 : 1) * (basePrice * 0.006 * ((i % 3) + 1));
      final open = current;
      final close = (open + trend).clamp(basePrice * 0.8, basePrice * 1.25);
      final high =
          (open > close ? open : close) + (basePrice * 0.004 * ((i % 2) + 1));
      final low =
          (open < close ? open : close) - (basePrice * 0.004 * ((i % 2) + 1));
      final volume = (basePrice * 0.5) * ((i % 4) + 1.2);

      candles.add(
        Candle(
          openTime: t,
          open: open,
          high: high,
          low: low,
          close: close,
          volume: volume,
        ),
      );
      current = close;
    }

    // Set last close to exact current price for consistency
    if (candles.isNotEmpty) {
      final last = candles.last;
      candles[candles.length - 1] = Candle(
        openTime: last.openTime,
        open: last.open,
        high: last.high > basePrice ? last.high : basePrice * 1.002,
        low: last.low < basePrice ? last.low : basePrice * 0.998,
        close: basePrice,
        volume: last.volume,
      );
    }

    return candles;
  }

  /// Moving average calculation helper
  static List<double?> calculateMA(List<Candle> candles, int period) {
    final List<double?> ma = [];
    for (int i = 0; i < candles.length; i++) {
      if (i < period - 1) {
        ma.add(null);
      } else {
        double sum = 0;
        for (int j = i - period + 1; j <= i; j++) {
          sum += candles[j].close;
        }
        ma.add(sum / period);
      }
    }
    return ma;
  }
}
