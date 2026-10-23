import '../models/order_book_level.dart';

class OrderBookSnapshot {
  final List<OrderBookLevel> bids;
  final List<OrderBookLevel> asks;
  final double spread;
  final double maxQuantity;

  const OrderBookSnapshot({
    required this.bids,
    required this.asks,
    required this.spread,
    required this.maxQuantity,
  });
}

abstract final class MockOrderBookFixture {
  static OrderBookSnapshot getOrderBook(double currentPrice) {
    final step = currentPrice * 0.0002;
    final List<OrderBookLevel> bids = [];
    final List<OrderBookLevel> asks = [];

    double maxQty = 0.0;

    // Generate 8 asks (higher than current price, ascending)
    double askCumulative = 0.0;
    for (int i = 1; i <= 8; i++) {
      final price = currentPrice + (i * step);
      final qty = (0.35 + (i * 0.18)) * (currentPrice > 1000 ? 1.0 : 100.0);
      askCumulative += qty;
      if (qty > maxQty) maxQty = qty;
      asks.add(
        OrderBookLevel(price: price, quantity: qty, total: askCumulative),
      );
    }

    // Generate 8 bids (lower than current price, descending)
    double bidCumulative = 0.0;
    for (int i = 1; i <= 8; i++) {
      final price = currentPrice - (i * step);
      final qty = (0.42 + (i * 0.15)) * (currentPrice > 1000 ? 1.0 : 100.0);
      bidCumulative += qty;
      if (qty > maxQty) maxQty = qty;
      bids.add(
        OrderBookLevel(price: price, quantity: qty, total: bidCumulative),
      );
    }

    final bestAsk = asks.isNotEmpty ? asks.first.price : currentPrice;
    final bestBid = bids.isNotEmpty ? bids.first.price : currentPrice;
    final spread = (bestAsk - bestBid).clamp(0.0, double.infinity);

    return OrderBookSnapshot(
      bids: bids,
      asks: asks,
      spread: spread,
      maxQuantity: maxQty,
    );
  }
}
