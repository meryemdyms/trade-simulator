
---
name: flutter-mock-interactions
description: Flutter UI'da arama, filtre, favori, Market/Limit, AL/SAT, demo bakiye, portföy, işlem geçmişi, bekleyen emirler, grafik seçimi ve fiyat alarmları gibi etkileşimler geliştirildiğinde kullan.
---

# FLUTTER MOCK INTERACTIONS

## 1. Temel Kural

Uygulama gerçek bir backend olmadan
etkileşimli çalışmalıdır.

Kullanılan veri kaynakları:
- Yerel fixture
- ChangeNotifier / ValueNotifier
- Widget state

HTTP, WebSocket, Firebase veya database yok.

## 2. Tek Demo State

Tüm ekranların kullandığı ortak state:

DemoAppState

Sorumlulukları:
- Market listesi
- Seçili varlık
- Favoriler
- Sanal nakit
- Coin pozisyonları
- İşlem geçmişi
- Bekleyen emirler
- Alarm kayıtları
- Para birimi görünümü

Aynı verinin farklı kopyalarını
bağımsız ekran state'lerinde tutma.

## 3. Market Asset Model

Dosya:
lib/mock/models/market_asset.dart

```dart
class MarketAsset {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String name;
  final double price;
  final double change24h;
  final double high24h;
  final double low24h;
  final double volume;
  final double quoteVolume;
  final double bidPrice;
  final double askPrice;

  const MarketAsset({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.name,
    required this.price,
    required this.change24h,
    required this.high24h,
    required this.low24h,
    required this.volume,
    required this.quoteVolume,
    required this.bidPrice,
    required this.askPrice,
  });

  bool get isPositive => change24h >= 0;
}
```

## 4. Mock Fixture

Dosya:
lib/mock/fixtures/market_fixture.dart

```dart
import '../models/market_asset.dart';

const mockMarkets = [
  MarketAsset(
    symbol: 'BTCUSDT',
    baseAsset: 'BTC',
    quoteAsset: 'USDT',
    name: 'Bitcoin',
    price: 67840.50,
    change24h: 3.85,
    high24h: 68450.00,
    low24h: 65120.00,
    volume: 12400,
    quoteVolume: 840000000,
    bidPrice: 67840.00,
    askPrice: 67845.00,
  ),
  MarketAsset(
    symbol: 'ETHUSDT',
    baseAsset: 'ETH',
    quoteAsset: 'USDT',
    name: 'Ethereum',
    price: 3520.10,
    change24h: 2.40,
    high24h: 3600.00,
    low24h: 3380.00,
    volume: 65000,
    quoteVolume: 228000000,
    bidPrice: 3519.90,
    askPrice: 3520.30,
  ),
  MarketAsset(
    symbol: 'SOLUSDT',
    baseAsset: 'SOL',
    quoteAsset: 'USDT',
    name: 'Solana',
    price: 184.25,
    change24h: 8.92,
    high24h: 190.00,
    low24h: 169.00,
    volume: 250000,
    quoteVolume: 46000000,
    bidPrice: 184.20,
    askPrice: 184.30,
  ),
];
```

Bütün fiyatlar örnek veridir.

Aynı fixture Markets, Detail ve Portfolio
ekranlarında kullanılmalıdır.

## 5. Search

Search query değiştiğinde:
- Symbol
- Base asset
- Full name

alanlarında eşleşme aranır.

Büyük/küçük harf duyarsız olmalı.

Boş sonuç:
"Aradığınız kripto para bulunamadı."

## 6. Market Filters

Tümü:
Tüm mock varlıklar.

Yükselenler:
change24h > 0.
En yüksekten en düşüğe.

Düşenler:
change24h < 0.
En negatif değerden başlayarak.

Yüksek Hacim:
quoteVolume büyükten küçüğe.

Favoriler:
Favori olarak işaretlenenler.

## 7. Favorites

Favori semboller tek ortak state'te saklanır.

Örnek state:

```dart
import 'package:flutter/foundation.dart';

class FavoritesState extends ChangeNotifier {
  final Set<String> _favorites = {};

  bool contains(String symbol) {
    return _favorites.contains(symbol);
  }

  void toggle(String symbol) {
    if (!_favorites.add(symbol)) {
      _favorites.remove(symbol);
    }
    notifyListeners();
  }

  Set<String> get values =>
      Set.unmodifiable(_favorites);
}
```

Bu yalnızca örnektir.

Gerçek uygulamada ortak DemoAppState zaten
favorileri yönetiyorsa ikinci state oluşturma.

## 8. Wallet

Başlangıç sanal sermayesi:
100.000 TRY.

TRY, USDT değildir.

Mock dönüşüm oranı gerekiyorsa
tek bir demo kur sabiti tanımla.

Demo kur açıkça belirtilmeli.

Piyasa işlemlerinin hesaplama
para birimi USDT olabilir.

Portföy gösterimi:
TRY veya USDT seçilebilir.

Güncel gerçek kur iddiası yok.

## 9. Trade Types

```dart
enum TradeSide {
  buy,
  sell,
}

enum OrderType {
  market,
  limit,
}

enum OrderStatus {
  pending,
  filled,
  cancelled,
}
```

Trade side ve order type farklı kavramlardır.

AL / SAT = İşlem yönü.
Market / Limit = Emir yöntemi.

## 10. Market Form

Market modunda:
- AL/SAT seçimi
- Kullanılabilir bakiye
- İşlem tutarı
- USDT/BTC giriş birimi
- Yüzde kısayolları
- Tahmini miktar
- Tahmini fiyat
- Komisyon
- İşlem butonu

Market AL:
Mock ask fiyatından hesapla.

Market SAT:
Mock bid fiyatından hesapla.

USDT girişinde:
quantity = enteredUSDT / estimatedPrice

BTC girişinde:
total = enteredBTC * estimatedPrice

Bu basitleştirilmiş demo hesaplamasıdır.

Komisyon varsayılanı:
%0 simüle komisyon.

Komisyon UI'da açıkça belirtilmeli.

## 11. Market İşlem Davranışı

AL:
- Yeterli sanal nakit olmalı.
- Alınan miktar portföye eklenir.
- Sanal nakit azalır.

SAT:
- Satılabilir coin yeterli olmalı.
- Coin miktarı azalır.
- Sanal nakit artar.

Her işlem:
- ID
- Symbol
- Side
- Type
- Quantity
- Price
- Total
- Timestamp

ile işlem geçmişine eklenir.

Confirmation bottom sheet olmadan
geri dönüşü olan bakiyeyi değiştirme.

## 12. Limit Form

Limit seçilince:
- Hedef Limit Fiyatı görünür.
- Güncel Fiyatı Kullan eylemi görünür.
- Miktar alanı görünür.
- Toplam tutar hesaplanır.
- Yüzde kısayolları korunur.
- USDT/BTC toggle gizlenir.

Formül:

total = limitPrice * quantity

Güncel Fiyatı Kullan:
Inputa ortak mock price değerini doldurur.

Bu özellik emir gerçekleştirmez.

## 13. Limit Emir Kuralları

Limit emirlerinin ilk UI sürümündeki durumu:
PENDING.

Limit AL:
- Yeterli bakiye doğrulanır.
- Tahmini toplam nakit bloke edilir.
- Emir bekleyenlere eklenir.

Limit SAT:
- Yeterli coin doğrulanır.
- Coin miktarı bloke edilir.
- Emir bekleyenlere eklenir.

İptal:
- Emir cancelled olur.
- Bloke edilen tutar serbest bırakılır.

Otomatik fill yok.
Matching engine yok.
Fiyat tetikleme servisi yok.
Gerçek emir defteriyle işlem yapma yok.

UI'da desteklenmeyen PARTIALLY_FILLED
durumunu çalışıyormuş gibi gösterme.

## 14. Financial Model

Portföyde ayrı tut:
- Available cash
- Reserved cash
- Available holdings
- Reserved holdings
- Average cost
- Realized P/L
- Unrealized P/L
- Transaction history

Portföyün hesapları tek para biriminde yapılmalı.

Current position value:
quantity * currentPrice

Remaining cost basis:
quantity * averageBuyPrice

Unrealized P/L:
currentValue - remainingCostBasis

Return %:
unrealizedPnL / remainingCostBasis * 100

RemainingCostBasis sıfırsa:
Return yüzdesi güvenli gösterilmeli.

Realized P/L:
Satış geliri - satılan miktarın maliyet payı.

Cash + reservedCash + holdingsValue
toplam portföy değerini oluşturur.

Reserved holdings zaten holdingsValue içinde
bulunuyorsa ayrıca tekrar ekleme.

Yüzde hesaplarında sıfıra bölünme engellenmeli.

## 15. Quantity and Decimal Rules

Finansal değerler için:
- Sayısal giriş kontrolü
- Negatif tutar kontrolü
- Sıfır kontrolü
- Ondalık hassasiyet
- Uygun formatlama
- Yuvarlama tutarlılığı

Yerel demo state'te double kullanılabilir.

Ancak gerçek trading entegrasyonu öncesinde
ondalık hassasiyet yaklaşımı yeniden ele alınmalıdır.

UI alanları hesaplamaları değiştirmemeli.

## 16. Portfolio Reset

Sıfırla butonu:
- Confirmation dialog açar.
- Kullanıcı onaylayınca çalışır.

Sıfırlanacaklar:
- Sanal nakit
- Pozisyonlar
- Reserved balance
- Bekleyen emirler
- İşlem geçmişi
- Finansal istatistikler

Başlangıç:
100.000 TRY sanal sermaye.

Favoriler ve alarm tercihleri
portföy sıfırlamasından bağımsız kalabilir.

## 17. Chart Interactions

Zaman aralıkları:
- 1S
- 1G
- 1H
- 1A
- Tümü

Grafik tipi:
- Mum
- Çizgi

Seçime göre ilgili mock fixture göster.

Ayrı candle listeleri kullanılabilir.

Gerçek zamanlı sahte WebSocket simülasyonu
oluşturmak zorunlu değildir.

## 18. Order Book

Yerel mock order book:
- Bids
- Asks
- Spread

Bids yüksek fiyattan düşüğe.
Asks düşük fiyattan yükseğe.

Her seviye:
- Fiyat
- Miktar
- Kümülatif veya parasal toplam

Depth bar genişliği miktara göre hesaplanır.

## 19. Trades Tab

Piyasa işlemleri mock fixture'dan gelir.

Her satır:
- Time
- Price
- Quantity
- Aggressor direction

AL yeşil.
SAT kırmızı.

Bu işlemler kullanıcının kendi
sanal işlem geçmişi değildir.

## 20. Price Alerts

Fiyat alarmı oluşturma UI:
- Coin
- Hedef fiyat
- Yukarı geçiş
- Aşağı geçiş
- Aktif/Pasif

Yerel mock state'te:
- Ekle
- Düzenle
- Sil
- Aç/kapat

Arka planda fiyat takip etme.
Push notification gönderme.

## 21. UI Feedback

- Form validation
- Snackbar
- Confirmation bottom sheet
- Empty state
- Disabled button
- Loading placeholder
- Demo badge
- Reset confirmation

Bütün görünür butonlar anlamlı
UI davranışına sahip olmalıdır.

## 22. Kabul Kriterleri

- Arama çalışır.
- Filtreler çalışır.
- Favoriler çalışır.
- AL / SAT değişir.
- Market / Limit değişir.
- Limit inputu koşullu görünür.
- Güncel Fiyatı Kullan çalışır.
- USDT/BTC Market giriş birimi değişir.
- Yüzde kısayolları çalışır.
- Bakiye doğrulanır.
- Demo Market işlemi portföyü günceller.
- Limit emir bekleyenlere eklenir.
- İptal çalışır.
- Portföy sıfırlanır.
- Hiçbir ağ bağlantısı kurulmaz.
