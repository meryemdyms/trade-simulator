import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

enum MarketFilter {
  all('Tümü'),
  gainers('Yükselenler'),
  losers('Düşenler'),
  highVolume('Yüksek Hacim'),
  favorites('Favoriler');

  final String label;
  const MarketFilter(this.label);
}

class FilterChipsRow extends StatelessWidget {
  final MarketFilter selectedFilter;
  final ValueChanged<MarketFilter> onSelected;

  const FilterChipsRow({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MarketFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = MarketFilter.values[index];
          final isSelected = filter == selectedFilter;

          return InkWell(
            onTap: () => onSelected(filter),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryContainer
                    : AppColors.surfaceLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                  width: isSelected ? 1.0 : 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  filter.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
