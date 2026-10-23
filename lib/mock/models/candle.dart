class Candle {
  final int openTime;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const Candle({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;
}
