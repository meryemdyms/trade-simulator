import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../utils/formatters.dart';

class MarketValueText extends StatelessWidget {
  final double value;
  final bool isPercentage;
  final String? prefix;
  final String? suffix;
  final double fontSize;
  final FontWeight fontWeight;
  final bool showPlusSign;

  const MarketValueText({
    super.key,
    required this.value,
    this.isPercentage = false,
    this.prefix,
    this.suffix,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.showPlusSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPos = value >= 0;
    final color = isPos ? AppColors.positive : AppColors.negative;

    String displayText;
    if (isPercentage) {
      displayText = AppFormatters.formatPercentage(value);
      if (!showPlusSign && displayText.startsWith('+')) {
        displayText = displayText.substring(1);
      }
    } else {
      final sign = isPos ? (showPlusSign ? '+' : '') : '-';
      displayText = '$sign${AppFormatters.formatNumber(value.abs())}';
    }

    if (prefix != null) {
      displayText = '$prefix$displayText';
    }
    if (suffix != null) {
      displayText = '$displayText$suffix';
    }

    return Text(
      displayText,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
