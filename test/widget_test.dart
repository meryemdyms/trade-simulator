import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aether_crypto/app/app.dart';
import 'package:aether_crypto/app/navigation/app_shell.dart';
import 'package:aether_crypto/features/asset_detail/views/asset_detail_screen.dart';
import 'package:aether_crypto/mock/models/virtual_order.dart';
import 'package:aether_crypto/mock/state/demo_app_state.dart';

void main() {
  setUp(() {
    DemoAppState().resetPortfolio();
  });

  group('DemoAppState Unit & Logic Tests', () {
    test('Initial portfolio balance should be configured correctly', () {
      final state = DemoAppState();
      expect(state.availableCashUsdt, greaterThan(2800));
      expect(state.availableCashTry, closeTo(100000.0, 1.0));
      expect(state.holdings.isEmpty, isTrue);
      expect(state.pendingOrders.isEmpty, isTrue);
    });

    test('Market Buy order executes and updates holdings and cash', () {
      final state = DemoAppState();
      final btc = state.markets.first; // BTCUSDT
      final initialCash = state.availableCashUsdt;

      const buyQty = 0.01;
      final price = btc.askPrice;
      final cost = buyQty * price;

      final success = state.executeMarketOrder(
        asset: btc,
        side: TradeSide.buy,
        quantity: buyQty,
        price: price,
      );

      expect(success, isTrue);
      expect(state.availableCashUsdt, closeTo(initialCash - cost, 0.01));
      expect(state.holdings.containsKey(btc.symbol), isTrue);
      expect(state.holdings[btc.symbol]!.quantity, closeTo(buyQty, 0.0001));
      expect(state.tradeHistory.length, 1);
      expect(state.tradeHistory.first.status, OrderStatus.filled);
    });

    test('Limit Buy order creates pending order and reserves cash', () {
      final state = DemoAppState();
      final btc = state.markets.first;
      final initialCash = state.availableCashUsdt;

      const buyQty = 0.01;
      const limitPrice = 60000.0;
      final total = buyQty * limitPrice;

      final success = state.createLimitOrder(
        asset: btc,
        side: TradeSide.buy,
        quantity: buyQty,
        limitPrice: limitPrice,
      );

      expect(success, isTrue);
      expect(state.reservedCashUsdt, closeTo(total, 0.01));
      expect(state.availableCashUsdt, closeTo(initialCash - total, 0.01));
      expect(state.pendingOrders.length, 1);
      expect(state.pendingOrders.first.status, OrderStatus.pending);

      // Cancel order
      final orderId = state.pendingOrders.first.id;
      final cancelSuccess = state.cancelLimitOrder(orderId);
      expect(cancelSuccess, isTrue);
      expect(state.reservedCashUsdt, 0.0);
      expect(state.availableCashUsdt, closeTo(initialCash, 0.01));
      expect(state.pendingOrders.isEmpty, isTrue);
    });

    test('Favorites toggle works as expected', () {
      final state = DemoAppState();
      const symbol = 'AVAXUSDT';
      final initialFav = state.isFavorite(symbol);

      state.toggleFavorite(symbol);
      expect(state.isFavorite(symbol), !initialFav);

      state.toggleFavorite(symbol);
      expect(state.isFavorite(symbol), initialFav);
    });
  });

  group('Widget UI Tests', () {
    testWidgets('App renders splash screen initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const AetherCryptoApp());
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Aether Crypto'), findsOneWidget);
      expect(find.text('Paper Trading & Sanal Terminal'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Advance timer and transition to AppShell
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();
    });

    testWidgets('AppShell renders 3 tabs and can navigate', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: AppShell()));
      await tester.pumpAndSettle();

      expect(find.text('Aether Markets'), findsOneWidget);
      expect(find.text('Piyasalar'), findsOneWidget);
      expect(find.text('Portföy'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);

      // Navigate to Portfolio Tab
      await tester.tap(find.text('Portföy'));
      await tester.pumpAndSettle();

      expect(find.text('Aether Portfolio'), findsOneWidget);
      expect(find.text('Toplam Sanal Servet'), findsOneWidget);

      // Navigate to Profile Tab
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      expect(find.text('Profil & Ayarlar'), findsOneWidget);
      expect(find.text('Sanal Yatırımcı'), findsOneWidget);
    });

    testWidgets(
      'AssetDetailScreen displays Market and Limit terminal correctly',
      (WidgetTester tester) async {
        final asset = DemoAppState().markets.first;

        await tester.pumpWidget(
          MaterialApp(home: AssetDetailScreen(asset: asset)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Simüle Alım-Satım'), findsOneWidget);
        expect(find.text('AL (BUY)'), findsOneWidget);
        expect(find.text('SAT (SELL)'), findsOneWidget);
        expect(find.text('Piyasa (Market)'), findsOneWidget);
        expect(find.text('Limit Emri'), findsOneWidget);

        // Switch to Limit Emri
        await tester.tap(find.text('Limit Emri'));
        await tester.pumpAndSettle();

        expect(find.text('Hedef Limit Fiyatı'), findsOneWidget);
        expect(find.text('Güncel Fiyatı Kullan'), findsOneWidget);
      },
    );
  });
}
