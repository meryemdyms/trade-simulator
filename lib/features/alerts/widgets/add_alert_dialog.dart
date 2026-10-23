import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../mock/state/demo_app_state.dart';

class AddAlertDialog extends StatefulWidget {
  final String? defaultSymbol;
  final double? defaultPrice;

  const AddAlertDialog({super.key, this.defaultSymbol, this.defaultPrice});

  @override
  State<AddAlertDialog> createState() => _AddAlertDialogState();
}

class _AddAlertDialogState extends State<AddAlertDialog> {
  late String _selectedSymbol;
  late TextEditingController _priceController;
  bool _isAbove = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final state = DemoAppState();
    _selectedSymbol = widget.defaultSymbol ?? state.markets.first.symbol;
    final initialPrice =
        widget.defaultPrice ??
        (state.findMarket(_selectedSymbol)?.price ?? 0.0);
    _priceController = TextEditingController(
      text: initialPrice.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _onSave() {
    final targetPrice = double.tryParse(_priceController.text.trim()) ?? 0.0;
    if (targetPrice <= 0) {
      setState(() => _error = 'Geçerli bir hedef fiyat girin.');
      return;
    }

    DemoAppState().addPriceAlert(
      symbol: _selectedSymbol,
      targetPrice: targetPrice,
      isAbove: _isAbove,
    );

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceHigh,
        content: Text(
          '$_selectedSymbol için demo fiyat alarmı oluşturuldu.',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return AlertDialog(
      title: const Text(
        'Fiyat Alarmı Ekle',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kripto Varlık',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedSymbol,
              dropdownColor: AppColors.surface,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: state.markets.map((m) {
                return DropdownMenuItem(
                  value: m.symbol,
                  child: Text('${m.baseAsset} / ${m.quoteAsset} (${m.name})'),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSymbol = val;
                    final p = state.findMarket(val)?.price ?? 0.0;
                    _priceController.text = p.toStringAsFixed(2);
                  });
                }
              },
            ),
            const SizedBox(height: 14),

            const Text(
              'Hedef Fiyat (USDT)',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: '0.00',
                suffixText: 'USDT',
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Tetiklenme Koşulu',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Üstüne Çıkınca'),
                    selected: _isAbove,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _isAbove = true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Altına İnince'),
                    selected: !_isAbove,
                    selectedColor: AppColors.primaryContainer,
                    onSelected: (val) => setState(() => _isAbove = false),
                  ),
                ),
              ],
            ),

            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(
                _error!,
                style: const TextStyle(fontSize: 12, color: AppColors.negative),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Vazgeç',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: _onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            minimumSize: const Size(90, 40),
          ),
          child: const Text('Alarmı Kur'),
        ),
      ],
    );
  }
}
