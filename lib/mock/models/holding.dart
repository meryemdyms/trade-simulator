class PortfolioHolding {
  final String symbol;
  final String baseAsset;
  final String name;
  final double quantity;
  final double reservedQuantity;
  final double averageCost;

  const PortfolioHolding({
    required this.symbol,
    required this.baseAsset,
    required this.name,
    required this.quantity,
    this.reservedQuantity = 0.0,
    required this.averageCost,
  });

  double get availableQuantity =>
      (quantity - reservedQuantity).clamp(0.0, double.infinity);

  double currentValue(double currentPrice) => quantity * currentPrice;

  double costBasis() => quantity * averageCost;

  double unrealizedPnL(double currentPrice) =>
      currentValue(currentPrice) - costBasis();

  double returnPercentage(double currentPrice) {
    final basis = costBasis();
    if (basis <= 0) return 0.0;
    return (unrealizedPnL(currentPrice) / basis) * 100;
  }

  PortfolioHolding copyWith({
    String? symbol,
    String? baseAsset,
    String? name,
    double? quantity,
    double? reservedQuantity,
    double? averageCost,
  }) {
    return PortfolioHolding(
      symbol: symbol ?? this.symbol,
      baseAsset: baseAsset ?? this.baseAsset,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      averageCost: averageCost ?? this.averageCost,
    );
  }
}
