import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../mock/state/demo_app_state.dart';

class ResetPortfolioDialog extends StatelessWidget {
  const ResetPortfolioDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.negative,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(
            'Portföyü Sıfırla',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      content: const Text(
        'Tüm pozisyonlarınız, bekleyen limit emirleriniz ve geçmiş işlemleriniz temizlenecek, sanal bakiyeniz 100.000 TL başlangıç sermayesine sıfırlanacaktır.\n\nOnaylıyor musunuz?',
        style: TextStyle(
          fontSize: 13,
          height: 1.4,
          color: AppColors.textSecondary,
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
          onPressed: () {
            DemoAppState().resetPortfolio();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.surfaceHigh,
                content: Text(
                  'Sanal portföy 100.000 TL başlangıç sermayesine sıfırlandı.',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.negative,
            foregroundColor: Colors.black,
            minimumSize: const Size(100, 40),
          ),
          child: const Text(
            'Sıfırla',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
