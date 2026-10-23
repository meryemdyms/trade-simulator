class MarketTrade {
  final int id;
  final double price;
  final double quantity;
  final int time;
  final bool isBuyerMaker;

  const MarketTrade({
    required this.id,
    required this.price,
    required this.quantity,
    required this.time,
    required this.isBuyerMaker,
  });

  bool get isBuy => !isBuyerMaker;
}
