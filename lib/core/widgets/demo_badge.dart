import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class DemoBadge extends StatelessWidget {
  final String label;
  final bool isWarning;

  const DemoBadge({super.key, this.label = 'DEMO', this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.primaryContainer.withValues(alpha: 0.18)
            : AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isWarning
              ? AppColors.primary.withValues(alpha: 0.4)
              : AppColors.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isWarning ? AppColors.primary : AppColors.outline,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: isWarning ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
