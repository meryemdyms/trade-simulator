import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../mock/state/demo_app_state.dart';
import '../widgets/add_alert_dialog.dart';
import '../widgets/alert_item_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DemoAppState();

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final alerts = state.priceAlerts;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Fiyat Alarmları',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                ),
                tooltip: 'Yeni Alarm',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => const AddAlertDialog(),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: alerts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: AppColors.outline.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Henüz bir fiyat alarmı bulunmuyor.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const AddAlertDialog(),
                          );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Alarm Oluştur'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          minimumSize: const Size(160, 44),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return AlertItemCard(
                      alert: alert,
                      onToggle: () => state.togglePriceAlert(alert.id),
                      onDelete: () => state.deletePriceAlert(alert.id),
                    );
                  },
                ),
        );
      },
    );
  }
}
