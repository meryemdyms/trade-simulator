import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/demo_badge.dart';
import '../../../mock/models/market_asset.dart';
import '../../../mock/models/virtual_order.dart';
import '../../../mock/state/demo_app_state.dart';
import 'trade_confirmation_sheet.dart';

enum MarketInputUnit {
  usdt('USDT'),
  crypto('KRİPTO');

  final String label;
  const MarketInputUnit(this.label);
}

class VirtualTradingPanel extends StatefulWidget {
  final MarketAsset asset;

  const VirtualTradingPanel({super.key, required this.asset});

  @override
  State<VirtualTradingPanel> createState() => _VirtualTradingPanelState();
}

class _VirtualTradingPanelState extends State<VirtualTradingPanel> {
  TradeSide _side = TradeSide.buy;
  OrderType _orderType = OrderType.market;
  MarketInputUnit _inputUnit = MarketInputUnit.usdt;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.asset.price.toStringAsFixed(2);
  }

  @override
  void didUpdateWidget(covariant VirtualTradingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset.symbol != widget.asset.symbol) {
      _priceController.text = widget.asset.price.toStringAsFixed(2);
      _amountController.clear();
      _errorMessage = null;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // Set input amount from percentage shortcuts (25%, 50%, 75%, 100%)
  void _applyPercentage(double fraction, DemoAppState state) {
    setState(() {
      _errorMessage = null;
      if (_side == TradeSide.buy) {
        final availableUsdt = state.availableCashUsdt;
        final targetUsdt = availableUsdt * fraction;

        if (_orderType == OrderType.limit) {
          final limitPrice =
              double.tryParse(_priceController.text.trim()) ??
              widget.asset.price;
          if (limitPrice > 0) {
            final qty = targetUsdt / limitPrice;
            _amountController.text = AppFormatters.formatCryptoAmount(
              qty,
              maxDecimals: 4,
            );
          }
        } else {
          // Market
          if (_inputUnit == MarketInputUnit.usdt) {
            _amountController.text = targetUsdt.toStringAsFixed(2);
          } else {
            final executionPrice = widget.asset.askPrice;
            final qty = targetUsdt / executionPrice;
            _amountController.text = AppFormatters.formatCryptoAmount(
              qty,
              maxDecimals: 4,
            );
          }
        }
      } else {
        // Sell side: based on available holding quantity
        final holding = state.holdings[widget.asset.symbol];
        final availableQty = holding?.availableQuantity ?? 0.0;
        final targetQty = availableQty * fraction;

        if (_orderType == OrderType.limit) {
          _amountController.text = AppFormatters.formatCryptoAmount(
            targetQty,
            maxDecimals: 4,
          );
        } else {
          if (_inputUnit == MarketInputUnit.crypto) {
            _amountController.text = AppFormatters.formatCryptoAmount(
              targetQty,
              maxDecimals: 4,
            );
          } else {
            final executionPrice = widget.asset.bidPrice;
            final usdtTotal = targetQty * executionPrice;
            _amountController.text = usdtTotal.toStringAsFixed(2);
          }
        }
      }
    });
  }

  void _onConfirmTrade() {
    final state = DemoAppState();
    final rawAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (rawAmount <= 0) {
      setState(() => _errorMessage = 'Lütfen geçerli bir miktar girin.');
      return;
    }

    double quantity = 0.0;
    double price = 0.0;
    double total = 0.0;

    if (_orderType == OrderType.market) {
      price = _side == TradeSide.buy
          ? widget.asset.askPrice
          : widget.asset.bidPrice;
      if (_inputUnit == MarketInputUnit.usdt) {
        total = rawAmount;
        quantity = total / price;
      } else {
        quantity = rawAmount;
        total = quantity * price;
      }

      // Check balance
      if (_side == TradeSide.buy && total > state.availableCashUsdt) {
        setState(() => _errorMessage = 'Yetersiz kullanılabilir sanal bakiye.');
        return;
      }
      if (_side == TradeSide.sell) {
        final holding = state.holdings[widget.asset.symbol];
        if (holding == null || holding.availableQuantity < quantity) {
          setState(
            () => _errorMessage = 'Yetersiz ${widget.asset.baseAsset} miktarı.',
          );
          return;
        }
      }
    } else {
      // Limit
      final limitPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
      if (limitPrice <= 0) {
        setState(
          () => _errorMessage = 'Lütfen geçerli bir hedef limit fiyatı girin.',
        );
        return;
      }
      price = limitPrice;
      quantity = rawAmount;
      total = quantity * price;

      // Check balance
      if (_side == TradeSide.buy && total > state.availableCashUsdt) {
        setState(
          () => _errorMessage = 'Limit alış için yetersiz sanal bakiye.',
        );
        return;
      }
      if (_side == TradeSide.sell) {
        final holding = state.holdings[widget.asset.symbol];
        if (holding == null || holding.availableQuantity < quantity) {
          setState(
            () => _errorMessage =
                'Limit satış için yetersiz ${widget.asset.baseAsset} miktarı.',
          );
          return;
        }
      }
    }

    setState(() => _errorMessage = null);

    // Open Confirmation BottomSheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) {
        return TradeConfirmationSheet(
          asset: widget.asset,
          side: _side,
          type: _orderType,
          quantity: quantity,
          price: price,
          total: total,
          onConfirm: () {
            if (_orderType == OrderType.market) {
              final ok = state.executeMarketOrder(
                asset: widget.asset,
                side: _side,
                quantity: quantity,
                price: price,
              );
              if (ok && mounted) {
                _amountController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceHigh,
                    content: Text(
                      'Piyasa ${_side == TradeSide.buy ? "alış" : "satış"} emri başarıyla simüle edildi.',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            } else {
              // Limit Order
              final ok = state.createLimitOrder(
                asset: widget.asset,
                side: _side,
                quantity: quantity,
                limitPrice: price,
              );
              if (ok && mounted) {
                _amountController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.surfaceHigh,
                    content: Text(
                      'Limit ${_side == TradeSide.buy ? "alış" : "satış"} emri bekleyen emirlere eklendi.',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final isBuy = _side == TradeSide.buy;
        final sideColor = isBuy ? AppColors.positive : AppColors.negative;
        final holding = state.holdings[widget.asset.symbol];
        final availableHoldingQty = holding?.availableQuantity ?? 0.0;

        // Current execution estimate
        final executionPrice = isBuy
            ? widget.asset.askPrice
            : widget.asset.bidPrice;
        final rawAmount = double.tryParse(_amountController.text.trim()) ?? 0.0;

        double calculatedQuantity = 0.0;
        double calculatedTotal = 0.0;

        if (_orderType == OrderType.market) {
          if (_inputUnit == MarketInputUnit.usdt) {
            calculatedTotal = rawAmount;
            calculatedQuantity = executionPrice > 0
                ? (calculatedTotal / executionPrice)
                : 0.0;
          } else {
            calculatedQuantity = rawAmount;
            calculatedTotal = calculatedQuantity * executionPrice;
          }
        } else {
          final limitP =
              double.tryParse(_priceController.text.trim()) ??
              widget.asset.price;
          calculatedQuantity = rawAmount;
          calculatedTotal = calculatedQuantity * limitP;
        }

        return AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Simüle Alım-Satım',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Risksiz Sanal İşlem',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                  DemoBadge(
                    label: _orderType == OrderType.market ? 'MARKET' : 'LIMIT',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. AL / SAT Segmented Control
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.outlineVariant,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _side = TradeSide.buy;
                            _errorMessage = null;
                          });
                        },
                        borderRadius: BorderRadius.circular(11),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isBuy
                                ? AppColors.positive
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              'AL (BUY)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isBuy
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _side = TradeSide.sell;
                            _errorMessage = null;
                          });
                        },
                        borderRadius: BorderRadius.circular(11),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isBuy
                                ? AppColors.negative
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              'SAT (SELL)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: !isBuy
                                    ? Colors.black
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // 2. Order Type Toggle (Market vs Limit)
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _orderTypeTab(
                        label: 'Piyasa (Market)',
                        isSelected: _orderType == OrderType.market,
                        onTap: () {
                          setState(() {
                            _orderType = OrderType.market;
                            _errorMessage = null;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _orderTypeTab(
                        label: 'Limit Emri',
                        isSelected: _orderType == OrderType.limit,
                        onTap: () {
                          setState(() {
                            _orderType = OrderType.limit;
                            _errorMessage = null;
                            if (_priceController.text.isEmpty) {
                              _priceController.text = widget.asset.price
                                  .toStringAsFixed(2);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 3. Available Balance Info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isBuy
                          ? 'Kullanılabilir Nakit:'
                          : 'Kullanılabilir Varlık:',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      isBuy
                          ? AppFormatters.formatCurrency(
                              state.availableCashUsdt,
                              currency: 'USDT',
                            )
                          : '${AppFormatters.formatCryptoAmount(availableHoldingQty, maxDecimals: 4)} ${widget.asset.baseAsset}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 4. Conditional Limit Target Price Input
              if (_orderType == OrderType.limit) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Hedef Limit Fiyatı',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _priceController.text = widget.asset.price
                              .toStringAsFixed(2);
                        });
                      },
                      child: const Text(
                        'Güncel Fiyatı Kullan',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    suffixText: widget.asset.quoteAsset,
                    suffixStyle: const TextStyle(
                      color: AppColors.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // 5. Amount Input & Unit Toggle (in Market Mode)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _orderType == OrderType.market
                        ? (_inputUnit == MarketInputUnit.usdt
                              ? 'İşlem Tutarı (USDT)'
                              : 'Miktar (${widget.asset.baseAsset})')
                        : 'Miktar (${widget.asset.baseAsset})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  // Market mode unit switch: USDT ⇄ BTC
                  if (_orderType == OrderType.market)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _inputUnit = _inputUnit == MarketInputUnit.usdt
                              ? MarketInputUnit.crypto
                              : MarketInputUnit.usdt;
                          _amountController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.swap_horiz,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _inputUnit == MarketInputUnit.usdt
                                  ? 'USDT ⇄ ${widget.asset.baseAsset}'
                                  : '${widget.asset.baseAsset} ⇄ USDT',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  suffixText: _orderType == OrderType.limit
                      ? widget.asset.baseAsset
                      : (_inputUnit == MarketInputUnit.usdt
                            ? 'USDT'
                            : widget.asset.baseAsset),
                  suffixStyle: const TextStyle(
                    color: AppColors.outline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 6. Percentage Shortcuts (25%, 50%, 75%, 100%)
              Row(
                children: [0.25, 0.50, 0.75, 1.0].map((fraction) {
                  final label = '${(fraction * 100).toInt()}%';
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: OutlinedButton(
                        onPressed: () => _applyPercentage(fraction, state),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          side: const BorderSide(
                            color: AppColors.outlineVariant,
                            width: 0.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: AppColors.surfaceLow,
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // 7. Order Calculation Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      'Tahmini Kripto Miktarı',
                      '${AppFormatters.formatCryptoAmount(calculatedQuantity, maxDecimals: 6)} ${widget.asset.baseAsset}',
                    ),
                    const SizedBox(height: 6),
                    _infoRow(
                      _orderType == OrderType.market
                          ? 'İşlem Gösterge Fiyatı'
                          : 'Limit Fiyatı',
                      AppFormatters.formatCurrency(
                        _orderType == OrderType.market
                            ? executionPrice
                            : (double.tryParse(_priceController.text) ??
                                  widget.asset.price),
                        currency: widget.asset.quoteAsset,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _infoRow(
                      'Simüle Komisyon (%0)',
                      '0.00 ${widget.asset.quoteAsset}',
                      valueColor: AppColors.positive,
                    ),
                    const Divider(
                      height: 12,
                      color: AppColors.outlineVariant,
                      thickness: 0.5,
                    ),
                    _infoRow(
                      'Toplam İşlem Değeri',
                      AppFormatters.formatCurrency(
                        calculatedTotal,
                        currency: widget.asset.quoteAsset,
                      ),
                      isBold: true,
                    ),
                  ],
                ),
              ),

              // 8. Limit Info Disclaimer
              if (_orderType == OrderType.limit) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Limit emriniz belirlediğiniz fiyatta veya daha avantajlı fiyatta bekleyen emirlere kaydedilir.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Error Message
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.negative,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // 9. Confirm Button
              ElevatedButton(
                onPressed: _onConfirmTrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sideColor,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _orderType == OrderType.market
                      ? '${isBuy ? "Demo Alış Yap" : "Demo Satış Yap"} (${widget.asset.baseAsset})'
                      : 'Limit ${isBuy ? "Alış" : "Satış"} Emri Oluştur',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderTypeTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceHigh : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 0.8)
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
