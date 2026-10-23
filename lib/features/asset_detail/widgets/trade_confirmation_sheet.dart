import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../mock/models/market_asset.dart';
import '../../../mock/models/virtual_order.dart';

class TradeConfirmationSheet extends StatelessWidget {
  final MarketAsset asset;
  final TradeSide side;
  final OrderType type;
  final double quantity;
  final double price;
  final double total;
  final VoidCallback onConfirm;

  const TradeConfirmationSheet({
    super.key,
    required this.asset,
    required this.side,
    required this.type,
    required this.quantity,
    required this.price,
    required this.total,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isBuy = side == TradeSide.buy;
    final sideColor = isBuy ? AppColors.positive : AppColors.negative;
    final sideText = isBuy ? 'ALIŞ' : 'SATIŞ';
    final typeText = type == OrderType.market
        ? 'Piyasa (Market)'
        : 'Limit Emri';

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Demo Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Demo İşlem Onayı',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const DemoBadge(label: 'SİMÜLE'),
            ],
          ),
          const SizedBox(height: 16),

          // Order Summary Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.outlineVariant, width: 0.5),
            ),
            child: Column(
              children: [
                _summaryRow(
                  'İşlem Yönü',
                  sideText,
                  valueColor: sideColor,
                  isBold: true,
                ),
                const SizedBox(height: 10),
                _summaryRow('Emir Tipi', typeText),
                const SizedBox(height: 10),
                _summaryRow(
                  'İşlem Çifti',
                  '${asset.baseAsset} / ${asset.quoteAsset}',
                ),
                const SizedBox(height: 10),
                _summaryRow(
                  type == OrderType.market
                      ? 'Gösterge Fiyatı'
                      : 'Hedef Limit Fiyatı',
                  AppFormatters.formatCurrency(
                    price,
                    currency: asset.quoteAsset,
                  ),
                ),
                const SizedBox(height: 10),
                _summaryRow(
                  'Miktar',
                  '${AppFormatters.formatCryptoAmount(quantity, maxDecimals: 6)} ${asset.baseAsset}',
                ),
                const SizedBox(height: 10),
                _summaryRow(
                  'Simüle Komisyon (%0)',
                  '0.00 ${asset.quoteAsset}',
                  valueColor: AppColors.positive,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    height: 1,
                    color: AppColors.outlineVariant,
                    thickness: 0.5,
                  ),
                ),
                _summaryRow(
                  'Toplam Tutar',
                  AppFormatters.formatCurrency(
                    total,
                    currency: asset.quoteAsset,
                  ),
                  isBold: true,
                  fontSize: 15,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Demo Notice
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.outline,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  type == OrderType.market
                      ? 'Bu işlem anlık simüle fiyatla hemen portföyünüze yansıyacaktır.'
                      : 'Limit emriniz bekleyen emirlere eklenecek ve ilgili tutar bloke edilecektir.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Confirm and Cancel buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.outlineVariant),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Vazgeç'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: sideColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Onayla ve ${isBuy ? "Al" : "Sat"}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
