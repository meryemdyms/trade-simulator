class MarketAsset {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String name;
  final double price;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume;
  final double quoteVolume;
  final double bidPrice;
  final double askPrice;
  final List<double> sparkline;

  const MarketAsset({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.name,
    required this.price,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume,
    required this.quoteVolume,
    required this.bidPrice,
    required this.askPrice,
    this.sparkline = const [],
  });

  bool get isPositive => change24h >= 0;

  MarketAsset copyWith({
    String? symbol,
    String? baseAsset,
    String? quoteAsset,
    String? name,
    double? price,
    double? change24h,
    double? high24h,
    double? low24h,
    double? volume,
    double? quoteVolume,
    double? bidPrice,
    double? askPrice,
    List<double>? sparkline,
  }) {
    return MarketAsset(
      symbol: symbol ?? this.symbol,
      baseAsset: baseAsset ?? this.baseAsset,
      quoteAsset: quoteAsset ?? this.quoteAsset,
      name: name ?? this.name,
      price: price ?? this.price,
      change24h: change24h ?? this.change24h,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      volume: volume ?? this.volume,
      quoteVolume: quoteVolume ?? this.quoteVolume,
      bidPrice: bidPrice ?? this.bidPrice,
      askPrice: askPrice ?? this.askPrice,
      sparkline: sparkline ?? this.sparkline,
    );
  }
}
