
# AETHER CRYPTO — PROJECT

## 1. Proje Tanımı

Aether Crypto; Flutter ile geliştirilen, kripto piyasalarını
takip etme ve sanal yatırım yapma odaklı mobil uygulamadır.

Hedef platformlar:
- iOS
- Android

Uygulamanın temel özellikleri:
- Kripto piyasaları
- Arama, sıralama ve favoriler
- Kripto detay ekranı
- Sanal AL/SAT
- Market ve Limit emirleri
- Mum ve çizgi grafikleri
- Emir Defteri (Depth)
- Gerçekleşen işlemler görünümü
- Sanal portföy
- İşlem geçmişi
- Bekleyen sanal emirler
- Portföy analizi
- Fiyat alarmları
- Profil ve ayarlar

Ürün sade, modern ve profesyonel bir fintech uygulamasıdır.
Binance'in karmaşık arayüzü kopyalanmaz.

## 2. Bu Aşamanın Kesin Kapsamı

SADECE FLUTTER UI GELİŞTİRİLECEK.

Yapılacak:
- Flutter ekranları
- Native Flutter widget'ları
- Material 3 tema
- Navigasyon
- Responsive yerleşimler
- Mock veri modelleri
- Yerel UI state
- Çalışan arama ve favoriler
- Market / Limit formları
- Demo alım-satım etkileşimleri
- Demo portföy yönetimi
- Mock grafikler
- Form doğrulamaları
- Loading / Empty / Error UI durumları
- Widget testleri

YAPILMAYACAK:
- Backend
- REST API bağlantısı
- WebSocket bağlantısı
- Dio / HTTP client
- Firebase / Supabase
- Veritabanı
- Gerçek authentication
- Kullanıcı kayıt/giriş servisi
- API anahtarı yönetimi
- Gerçek Binance emri
- Gerçek para transferi
- Push notification altyapısı
- Sunucu tarafı hesaplama
- Gerçek emir eşleştirme motoru

Tüm piyasa bilgileri yerel mock veri olacaktır.

Binance API sözleşmeleri sadece ilerideki
entegrasyonun UI veri gereksinimlerini belirler.

## 3. Teknoloji Kararları

- Flutter stable
- Dart
- Material 3
- Feature-first architecture
- StatefulWidget
- ValueNotifier / ChangeNotifier
- Yerel mock state
- Native navigation
- Widget bileşenleri

Basit UI için ağır state management kullanma.


Grafikler Flutter CustomPainter veya
uygun bir Flutter grafik paketiyle oluşturulabilir.

Sadece gerçekten gerekli paketleri ekle.

## 4. Tasarım Kaynağı

Marka: Aether Crypto

Kaynak: Google Stitch ile oluşturulmuş dört temel tasarım:
1. Piyasalar Canlı Kripto Takip
2. BTC/USDT Detay & Sanal İşlem Terminali
3. Portföy / Sanal Bakiye / Varlık Dağılımı
4. Paper Trading Tanıtım Ekranı



Görsel kurallar:
.agents/skills/flutter-design-system/SKILL.md

Ekranların hiyerarşisi:
.agents/skills/flutter-screen-builder/SKILL.md

Gerekli tasarım kararları Markdown içinde bulunur.
Harici ZIP veya HTML dosyası bekleme.

## 5. Tasarım Kimliği

- Premium dark fintech
- Koyu lacivert yüzeyler
- İndigo aksanlar
- Yeşil alış ve pozitif değerler
- Kırmızı satış ve negatif değerler
- Inter tipografi
- Mikro sınırlar
- Hafif cam yüzey hissi
- Kompakt finans listeleri
- Sade hiyerarşi

Tema tokenları skill dosyasında sabittir.

## 6. Ekranlar

### 6.1 Splash

- Uygulama logosu
- Aether Crypto yazısı
- Kısa açılış animasyonu
- Ana ekrana geçiş

### 6.2 Welcome

- Tanıtım başlığı
- Sanal yatırım açıklaması
- Grafik ve emir defteri özellikleri
- 100.000 TL demo bakiye bilgisi
- Piyasaları Keşfet butonu

Gerçek kullanıcı hesabı oluşturulmaz.
Onboarding zorunlu değildir.

### 6.3 Piyasalar

- Aether Markets başlığı
- Bildirim ikonu
- Arama
- Piyasa özet kartları
- Günün yükseleni
- Korku & Açgözlülük kartı
- Tümü / Yükselenler / Düşenler /
  Yüksek Hacim / Favoriler
- Kripto listesi
- Sembol / fiyat / değişim / hacim
- 24 saatlik mini grafik
- Favori yıldızı
- Sanal portföye hızlı erişim
- Bottom navigation

### 6.4 Kripto Detay

- Kripto sembolü ve paritesi
- Spot / Demo bilgisi
- Favori ve alarm ikonu
- Güncel fiyat
- 24 saatlik değişim
- 24 saatlik yüksek / düşük / hacim
- Sanal işlem terminali
- AL / SAT
- Market / Limit
- Tutar / miktar / limit fiyatı
- Grafik
- Emir Defteri / Canlı İşlemler
- Risk bilgilendirmesi

### 6.5 Portföy

- Toplam sanal portföy değeri
- Kullanılabilir nakit
- Günlük ve toplam P/L
- Portföy dağılım grafiği
- Varlıklarım
- İşlem geçmişi
- Bekleyen Limit emirleri
- Demo performans istatistikleri
- Portföy sıfırlama

### 6.6 Profil

- Demo kullanıcı profili
- Tema tercihi
- Para birimi görünümü
- Bildirim tercihleri
- Fiyat alarmı yönetimi
- Sanal portföy sıfırlama
- Hakkında

## 7. Navigasyon

Ana tablar yalnızca:
1. Piyasalar
2. Portföy
3. Profil

Akış:

Splash -> Piyasalar

Piyasalar -> Kripto Detay

Kripto Detay:
- Sanal Al/Sat
- Grafik
- Emir Defteri / Canlı İşlemler

Portföy:
- Varlıklarım
- İşlem Geçmişi
- Bekleyen Emirler
- İstatistikler

Arama, favori, Market/Limit ve AL/SAT
için ayrı ana navigasyon sekmesi açma.

## 8. Sanal Trading Kararları

Başlangıç sermayesi: 100.000 TRY.

Gerçek Binance işlemi gönderilmez.

Kullanıcı:
- AL veya SAT seçer.
- Market veya Limit seçer.
- İşlem tutarı veya miktarı belirler.
- Demo işlem önizlemesini görür.
- Onay verir.

Market:
- Piyasa fiyatına dayalı demo işlem.
- Market AL fiyatı mock ask üzerinden.
- Market SAT fiyatı mock bid üzerinden.
- Miktar veya USDT tutarı girişi.
- Anında demo işlem sonucu.

Limit:
- Kullanıcı hedef fiyat belirler.
- Kullanıcı miktar belirler.
- Toplam tutar otomatik hesaplanır.
- Limit emirleri bekleyen emirler listesine eklenir.
- Bakiye veya varlık miktarı bloke edilir.
- İptal edilirse bloke çözülür.
- Otomatik matching engine oluşturulmaz.

Market ve Limit tasarımlarının ayrıntıları:
flutter-screen-builder/SKILL.md

## 9. Para Birimi

Başlangıç sermayesi 100.000 TRY'dir.

Piyasa işlem çiftleri USDT bazlıdır.

TRY ve USDT birbirine eşit kabul edilmez.

Mock trading için tek bir sabit demo dönüşüm oranı
kullanılabilir; bu değer tek fixture içinde tutulur.

Demo kur, gerçek döviz kuru olarak sunulmaz.

Portföyün:
- Baz hesaplama para birimi
- Gösterim para birimi
- Sanal nakit bakiyesi

birbirinden ayrılmalıdır.

Aynı tutar yanlışlıkla hem nakit hem pozisyon
olarak iki defa hesaplanmamalıdır.

## 10. Veri Kaynakları

Bu sürümde:
- MockMarketFixture
- MockCandleFixture
- MockOrderBookFixture
- MockTradesFixture
- DemoAppState

kullanılır.

Aynı varlığın fiyatı farklı ekranlarda
birbirinden bağımsız hardcode edilmez.

Piyasa fiyatlarının gerçek zamanlı aktığı iddia edilmez.

Piyasa verisi mock,
işlem ve portföy bilgisi sanaldır.

UI'da bu ayrım anlaşılır olmalıdır.

## 11. API Sözleşmeleri

REST:
- exchangeInfo
- ticker/24hr
- klines
- depth
- trades
- ticker/bookTicker
- ticker/price

WebSocket:
- !ticker@arr
- symbol@ticker
- symbol@kline
- symbol@depth20
- symbol@trade
- symbol@bookTicker

Bu isimler sadece referanstır.

Gerçek entegrasyon kesinlikle oluşturulmaz.

Detaylı alan eşleştirmeleri:
binance-ui-contracts/SKILL.md

## 12. Klasör Yapısı

lib/
  main.dart
  app/
    app.dart
    navigation/
      app_shell.dart
    theme/
      app_colors.dart
      app_theme.dart
      app_typography.dart

  core/
    widgets/
      app_card.dart
      demo_badge.dart
      market_value_text.dart
    utils/
      formatters.dart

  features/
    splash/
      views/
      widgets/
    welcome/
      views/
      widgets/
    markets/
      views/
      widgets/
    asset_detail/
      views/
      widgets/
    portfolio/
      views/
      widgets/
    profile/
      views/
      widgets/
    alerts/
      views/
      widgets/

  mock/
    models/
      market_asset.dart
      candle.dart
      order_book_level.dart
      market_trade.dart
      virtual_order.dart
      holding.dart
      price_alert.dart
    fixtures/
      market_fixture.dart
      chart_fixture.dart
      order_book_fixture.dart
      trades_fixture.dart
    state/
      demo_app_state.dart

test/
  widget_test.dart

Backend, network, datasource veya
gerçek servis implementasyonu oluşturma.

## 13. UI Davranışları

Çalışması zorunlu:
- Bottom navigation
- Kripto detaya geçiş
- Arama
- Filtreleme
- Favoriler
- AL/SAT toggle
- Market/Limit toggle
- Sayısal inputlar
- 25/50/75/100 kısayolları
- Demo işlem onayı
- Portföy güncellemesi
- Bekleyen limit emri
- Limit emir iptali
- Grafik türü/periyot seçimi
- Emir Defteri/Canlı İşlemler tabı
- Fiyat alarmı formu
- Portföy sıfırlama onayı

## 14. Kalite Kriterleri

- Tasarım tutarlılığı
- Responsive düzen
- SafeArea
- Klavye açıldığında erişilebilir form
- Sayısal biçimlendirme
- Overflow bulunmaması
- Demo etiketi
- Empty state
- Error / loading mock state
- Widget testleri
- dart format
- flutter analyze

## 15. Geliştirme Sırası

1. Flutter proje iskeleti
2. Theme + ortak widget'lar
3. Mock modeller + fixture'lar
4. DemoAppState
5. Splash / Welcome
6. Piyasalar
7. Kripto Detay
8. Market / Limit Trading Panel
9. Portföy
10. Profil / Alarmlar
11. UI testleri
12. Görsel iyileştirme

Kapsamı kendiliğinden genişletme.
