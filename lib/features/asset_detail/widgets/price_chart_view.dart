import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../mock/fixtures/chart_fixture.dart';
import '../../../mock/models/candle.dart';

enum ChartType {
  candle('Mum'),
  line('Çizgi');

  final String label;
  const ChartType(this.label);
}

class PriceChartView extends StatefulWidget {
  final String symbol;
  final double currentPrice;

  const PriceChartView({
    super.key,
    required this.symbol,
    required this.currentPrice,
  });

  @override
  State<PriceChartView> createState() => _PriceChartViewState();
}

class _PriceChartViewState extends State<PriceChartView> {
  String _selectedPeriod = '1G';
  ChartType _chartType = ChartType.candle;
  Candle? _hoveredCandle;

  final List<String> _periods = ['1S', '1G', '1H', '1A', 'Tümü'];

  @override
  Widget build(BuildContext context) {
    final candles = MockChartFixture.getCandles(widget.symbol, _selectedPeriod);
    final ma7 = MockChartFixture.calculateMA(candles, 7);
    final ma25 = MockChartFixture.calculateMA(candles, 25);

    final displayCandle =
        _hoveredCandle ?? (candles.isNotEmpty ? candles.last : null);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period Selector & Chart Type Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Periods (1S, 1G, 1H, 1A, Tümü)
              Row(
                children: _periods.map((period) {
                  final isSelected = period == _selectedPeriod;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPeriod = period;
                        _hoveredCandle = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.surfaceHigh
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 0.8)
                            : null,
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Chart Type Toggle
              Row(
                children: [
                  _chartTypeButton(ChartType.candle, Icons.candlestick_chart),
                  const SizedBox(width: 4),
                  _chartTypeButton(ChartType.line, Icons.show_chart),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // OHLC Header & Indicators Info Bar
          if (displayCandle != null)
            Row(
              children: [
                _ohlcItem('A', displayCandle.open),
                const SizedBox(width: 8),
                _ohlcItem('Y', displayCandle.high),
                const SizedBox(width: 8),
                _ohlcItem('D', displayCandle.low),
                const SizedBox(width: 8),
                _ohlcItem('K', displayCandle.close),
                const Spacer(),
                const Text(
                  'MA7',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFB74D),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'MA25',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF81D4FA),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Interactive Chart Canvas
          GestureDetector(
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null && candles.isNotEmpty) {
                final localX = details.localPosition.dx.clamp(
                  0.0,
                  box.size.width - 40,
                );
                final index =
                    ((localX / (box.size.width - 40)) * (candles.length - 1))
                        .round()
                        .clamp(0, candles.length - 1);
                setState(() => _hoveredCandle = candles[index]);
              }
            },
            onPanEnd: (_) => setState(() => _hoveredCandle = null),
            onTapDown: (details) {
              final box = context.findRenderObject() as RenderBox?;
              if (box != null && candles.isNotEmpty) {
                final localX = details.localPosition.dx.clamp(
                  0.0,
                  box.size.width - 40,
                );
                final index =
                    ((localX / (box.size.width - 40)) * (candles.length - 1))
                        .round()
                        .clamp(0, candles.length - 1);
                setState(() => _hoveredCandle = candles[index]);
              }
            },
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: CustomPaint(
                painter: _CandleChartPainter(
                  candles: candles,
                  ma7: ma7,
                  ma25: ma25,
                  chartType: _chartType,
                  hoveredCandle: _hoveredCandle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartTypeButton(ChartType type, IconData icon) {
    final isSelected = _chartType == type;
    return InkWell(
      onTap: () => setState(() => _chartType = type),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? AppColors.primary : AppColors.outline,
        ),
      ),
    );
  }

  Widget _ohlcItem(String label, double val) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 10, color: AppColors.outline),
        ),
        Text(
          AppFormatters.formatNumber(val, minDecimals: 2, maxDecimals: 2),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  final List<Candle> candles;
  final List<double?> ma7;
  final List<double?> ma25;
  final ChartType chartType;
  final Candle? hoveredCandle;

  _CandleChartPainter({
    required this.candles,
    required this.ma7,
    required this.ma25,
    required this.chartType,
    this.hoveredCandle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final priceAreaWidth = size.width - 50;
    final priceAreaHeight = size.height - 35;
    final volumeAreaHeight = 30.0;
    final chartHeight = priceAreaHeight - volumeAreaHeight;

    // Find min and max values
    double minPrice = double.infinity;
    double maxPrice = -double.infinity;
    double maxVolume = 0.0;

    for (final c in candles) {
      if (c.low < minPrice) minPrice = c.low;
      if (c.high > maxPrice) maxPrice = c.high;
      if (c.volume > maxVolume) maxVolume = c.volume;
    }

    // Safety padding for min/max
    final priceRange = (maxPrice - minPrice) == 0 ? 1.0 : (maxPrice - minPrice);
    minPrice -= priceRange * 0.03;
    maxPrice += priceRange * 0.03;
    final effectiveRange = maxPrice - minPrice;

    // 1. Draw Grid Lines & Price Labels
    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withValues(alpha: 0.35)
      ..strokeWidth = 0.5;

    final textStyle = const TextStyle(
      fontSize: 9,
      color: AppColors.outline,
      fontWeight: FontWeight.w500,
    );

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = (chartHeight / gridLines) * i;
      canvas.drawLine(Offset(0, y), Offset(priceAreaWidth, y), gridPaint);

      final priceLabel = maxPrice - (effectiveRange / gridLines) * i;
      final textSpan = TextSpan(
        text: AppFormatters.formatNumber(
          priceLabel,
          minDecimals: 1,
          maxDecimals: 1,
        ),
        style: textStyle,
      );
      final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(canvas, Offset(priceAreaWidth + 6, y - (tp.height / 2)));
    }

    final candleCount = candles.length;
    final stepX = priceAreaWidth / (candleCount > 1 ? candleCount - 1 : 1);
    final candleWidth = (stepX * 0.65).clamp(2.0, 10.0);

    // 2. Draw Volume Bars
    final maxVolSafe = maxVolume == 0 ? 1.0 : maxVolume;
    for (int i = 0; i < candleCount; i++) {
      final c = candles[i];
      final x = i * stepX;
      final volH = (c.volume / maxVolSafe) * (volumeAreaHeight - 6);
      final volY = priceAreaHeight - volH;

      final volPaint = Paint()
        ..color = (c.isBullish ? AppColors.positive : AppColors.negative)
            .withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(x - (candleWidth / 2), volY, candleWidth, volH),
        volPaint,
      );
    }

    // 3. Draw Candlestick or Line
    if (chartType == ChartType.candle) {
      for (int i = 0; i < candleCount; i++) {
        final c = candles[i];
        final x = i * stepX;

        final openY =
            chartHeight - ((c.open - minPrice) / effectiveRange) * chartHeight;
        final closeY =
            chartHeight - ((c.close - minPrice) / effectiveRange) * chartHeight;
        final highY =
            chartHeight - ((c.high - minPrice) / effectiveRange) * chartHeight;
        final lowY =
            chartHeight - ((c.low - minPrice) / effectiveRange) * chartHeight;

        final candleColor = c.isBullish
            ? AppColors.positive
            : AppColors.negative;

        // Wick line
        final wickPaint = Paint()
          ..color = candleColor
          ..strokeWidth = 1.0;
        canvas.drawLine(Offset(x, highY), Offset(x, lowY), wickPaint);

        // Body rect
        final bodyTop = openY < closeY ? openY : closeY;
        final bodyHeight = (openY - closeY).abs().clamp(1.5, double.infinity);

        final bodyPaint = Paint()
          ..color = candleColor
          ..style = PaintingStyle.fill;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x - (candleWidth / 2),
              bodyTop,
              candleWidth,
              bodyHeight,
            ),
            const Radius.circular(1.5),
          ),
          bodyPaint,
        );
      }
    } else {
      // Line Chart
      final linePath = Path();
      final fillPath = Path();

      for (int i = 0; i < candleCount; i++) {
        final x = i * stepX;
        final y =
            chartHeight -
            ((candles[i].close - minPrice) / effectiveRange) * chartHeight;

        if (i == 0) {
          linePath.moveTo(x, y);
          fillPath.moveTo(x, chartHeight);
          fillPath.lineTo(x, y);
        } else {
          linePath.lineTo(x, y);
          fillPath.lineTo(x, y);
        }
      }

      fillPath.lineTo(priceAreaWidth, chartHeight);
      fillPath.close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryContainer.withValues(alpha: 0.35),
            AppColors.primaryContainer.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, priceAreaWidth, chartHeight));

      canvas.drawPath(fillPath, fillPaint);

      final linePaint = Paint()
        ..color = AppColors.primary
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      canvas.drawPath(linePath, linePaint);
    }

    // 4. Draw MA7 & MA25 lines
    _drawMA(
      canvas,
      ma7,
      const Color(0xFFFFB74D),
      stepX,
      minPrice,
      effectiveRange,
      chartHeight,
    );
    _drawMA(
      canvas,
      ma25,
      const Color(0xFF81D4FA),
      stepX,
      minPrice,
      effectiveRange,
      chartHeight,
    );

    // 5. Draw Crosshair / Hover line if selected
    if (hoveredCandle != null) {
      final index = candles.indexOf(hoveredCandle!);
      if (index != -1) {
        final x = index * stepX;
        final crosshairPaint = Paint()
          ..color = AppColors.primary.withValues(alpha: 0.7)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

        canvas.drawLine(
          Offset(x, 0),
          Offset(x, priceAreaHeight),
          crosshairPaint,
        );
      }
    }
  }

  void _drawMA(
    Canvas canvas,
    List<double?> ma,
    Color color,
    double stepX,
    double minPrice,
    double effectiveRange,
    double chartHeight,
  ) {
    final path = Path();
    bool started = false;

    for (int i = 0; i < ma.length; i++) {
      final val = ma[i];
      if (val != null) {
        final x = i * stepX;
        final y =
            chartHeight - ((val - minPrice) / effectiveRange) * chartHeight;
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
    }

    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) {
    return oldDelegate.candles != candles ||
        oldDelegate.chartType != chartType ||
        oldDelegate.hoveredCandle != hoveredCandle;
  }
}
