class PriceAlert {
  final String id;
  final String symbol;
  final double targetPrice;
  final bool isAbove;
  final bool isActive;
  final int createdAt;

  const PriceAlert({
    required this.id,
    required this.symbol,
    required this.targetPrice,
    required this.isAbove,
    this.isActive = true,
    required this.createdAt,
  });

  PriceAlert copyWith({
    String? id,
    String? symbol,
    double? targetPrice,
    bool? isAbove,
    bool? isActive,
    int? createdAt,
  }) {
    return PriceAlert(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      targetPrice: targetPrice ?? this.targetPrice,
      isAbove: isAbove ?? this.isAbove,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
