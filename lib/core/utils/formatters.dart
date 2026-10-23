abstract final class AppFormatters {
  /// Format double with thousands separators and given decimal places
  static String formatNumber(
    double value, {
    int minDecimals = 2,
    int maxDecimals = 2,
  }) {
    final isNegative = value < 0;
    final absVal = value.abs();

    // Split into integer and decimal parts
    final parts = absVal.toStringAsFixed(maxDecimals).split('.');
    final integerPart = parts[0];
    var decimalPart = parts.length > 1 ? parts[1] : '';

    // Strip trailing zeros if decimals exceed minDecimals
    while (decimalPart.length > minDecimals && decimalPart.endsWith('0')) {
      decimalPart = decimalPart.substring(0, decimalPart.length - 1);
    }

    // Format integer with commas or periods
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    final formatted = decimalPart.isEmpty
        ? buffer.toString()
        : '${buffer.toString()}.$decimalPart';
    return isNegative ? '-$formatted' : formatted;
  }

  /// Format as currency with symbol (TRY or USDT)
  static String formatCurrency(
    double amount, {
    String currency = 'TRY',
    int decimals = 2,
  }) {
    final formatted = formatNumber(
      amount,
      minDecimals: decimals,
      maxDecimals: decimals,
    );
    if (currency == 'TRY' || currency == 'TL') {
      return '$formatted ₺';
    } else if (currency == 'USDT' || currency == 'USD') {
      return '\$$formatted';
    }
    return '$formatted $currency';
  }

  /// Format crypto quantity (up to 6 decimals, without excessive trailing zeros)
  static String formatCryptoAmount(double amount, {int maxDecimals = 6}) {
    if (amount >= 1000) {
      return formatNumber(amount, minDecimals: 2, maxDecimals: 2);
    }
    return formatNumber(amount, minDecimals: 2, maxDecimals: maxDecimals);
  }

  /// Format percentage with + or - sign
  static String formatPercentage(double percent) {
    final prefix = percent > 0 ? '+' : '';
    return '$prefix${percent.toStringAsFixed(2)}%';
  }

  /// Format timestamp (milliseconds since epoch) to HH:mm:ss
  static String formatTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  /// Format timestamp to DD.MM.YYYY HH:mm
  static String formatDateTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$day.$month.$year $h:$m';
  }

  /// Compact volume formatter (e.g. 840M, 12.4K)
  static String formatCompactNumber(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(2)}B';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(2);
  }
}
