enum TradeSide { buy, sell }

enum OrderType { market, limit }

enum OrderStatus { pending, filled, cancelled }

class VirtualOrder {
  final String id;
  final String symbol;
  final String baseAsset;
  final TradeSide side;
  final OrderType type;
  final double quantity;
  final double price;
  final double total;
  final OrderStatus status;
  final int createdAt;

  const VirtualOrder({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.side,
    required this.type,
    required this.quantity,
    required this.price,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  VirtualOrder copyWith({
    String? id,
    String? symbol,
    String? baseAsset,
    TradeSide? side,
    OrderType? type,
    double? quantity,
    double? price,
    double? total,
    OrderStatus? status,
    int? createdAt,
  }) {
    return VirtualOrder(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      baseAsset: baseAsset ?? this.baseAsset,
      side: side ?? this.side,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
