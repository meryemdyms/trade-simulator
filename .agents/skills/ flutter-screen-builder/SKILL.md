
---
name: flutter-screen-builder
description: Flutter ekranı, route, sayfa iskeleti, widget hiyerarşisi ve mevcut Stitch ekranlarının Flutter karşılıkları oluşturulurken veya düzenlenirken kullan. Güncel Market/Limit işlem terminalini esas alır.
---

# FLUTTER SCREEN BUILDER

## 1. Amaç

Aether Crypto Stitch ekranlarını native Flutter
widget'larıyla oluşturmak.

HTML, WebView ve JavaScript kullanma.

Tasarımların bölüm sırası, renkleri,
typography ve görsel yoğunluğu korunmalıdır.

Güncel Market / Limit tasarımı esas alınır.

Ek ZIP veya HTML dosyası bekleme.

## 2. Genel Widget Kuralları

Temel bileşenler:
- Scaffold
- SafeArea
- CustomScrollView
- SliverList
- Row / Column
- Card / Container
- TextField
- NavigationBar
- SegmentedButton
- BottomSheet
- AlertDialog
- CustomPainter
- IconButton

Tekrarlanan bileşenleri widgets/
klasörüne ayır.

## 3. Splash Screen

Yerleşim:

Scaffold
 └─ Center
     └─ Column
         ├─ Brand logo
         ├─ Aether Crypto
         └─ Kısa loading indicator

Renk:
#0D1322

Logo mümkün olduğunca sade.
Kısa animasyon.

Network veya auth kontrolü yok.

Bitişte Piyasalar sayfasına geç.

## 4. Welcome Screen

Stitch tanıtım tasarımının bölümleri:

Üst:
- Aether Crypto logosu
- Minimal terminal görünümü
- Demo etiketi

Ana başlık:
"Gerçek Piyasa Verisi,
Risksiz Simülasyon."

Bu ürün hedefini açıklayan tanıtım metnidir.
Mevcut UI sürümü canlı bağlı değildir.

Tanıtım özellikleri:
1. Binance Emir Defteri
2. 100.000 TL Sanal Bakiye
3. Profesyonel Mum Grafikleri
4. Piyasa Derinliği

CTA:
"Piyasaları Keşfet & Alım-Satıma Başla"

Alt bilgi:
"Tamamen simüle edilmiş işlem deneyimi."

Eski Stitch tasarımındaki:
- 50.000 USDT başlangıç
- Zorunlu giriş ekranı
- Ayarlanabilir sermaye seçenekleri
- Sıfır gecikmeli canlı bağlantı iddiası

kullanılmayacak.

Welcome ayrı sayfadır.
Gerçek auth akışı değildir.

## 5. Markets Screen

Kaynak:
Piyasalar Canlı Kripto Takip

### Hiyerarşi

MarketsScreen
 ├─ Header
 │   ├─ Aether Markets
 │   └─ Bildirim ikonu
 ├─ Market Status Strip
 ├─ Search
 ├─ Overview Cards
 │   ├─ Toplam Piyasa Değeri
 │   ├─ Günün Parlayanı
 │   └─ Korku & Açgözlülük
 ├─ Filters
 ├─ Market List
 ├─ Portfolio Quick Access
 └─ Bottom Navigation

### 5.1 Header

Başlık:
Aether Markets

Sağ:
Bildirim ikonu

Status:
"Demo Piyasa Verisi"

Gerçek WebSocket varmış gibi
"Live Connected" yazma.

### 5.2 Search

Placeholder:
"Kripto ara..."

Arama:
- Symbol
- Coin name

İsim veya sembol içeren kayıtlar filtrelenir.

### 5.3 Overview Cards

Stitch düzeni:

Toplam Piyasa Değeri:
- Büyük değer
- Günlük yüzde
- Net giriş bilgisi

Günün Parlayanı:
- Kripto sembolü
- Fiyat
- Günlük değişim
- Hacim

Korku & Açgözlülük:
- Sayısal endeks
- Kategori
- Önceki değer

Bu kartların verisi yalnızca Binance Spot ticker
alanlarından doğrudan sağlanamaz.

Mock kartlar olacak.
Örnek veri etiketi kullanılacak.

### 5.4 Filters

- Tümü
- Yükselenler
- Düşenler
- Yüksek Hacim
- Favoriler

Yatay kaydırılabilir chip row.

### 5.5 Market List

Kolon başlıkları:
- Varlık / Hacim
- Grafik (24s)
- Fiyat / Değişim

Satır:
- Coin icon
- Symbol
- Full name
- Hacim
- Sparkline
- Fiyat
- 24s yüzde
- Favori

Mock coin listesi:
BTC, ETH, SOL, SUI, BNB, AVAX, XRP, ADA.

Coin'e tıklama:
AssetDetailScreen.

Favoriye tıklama:
Favori state'i değişir.

### 5.6 Portfolio Quick Access

Kart:
- Sanal Portföy başlığı
- Demo bakiye özeti
- Simülasyon modu
- Hızlı erişim

Hızlı Al/Sat:
Seçilen coin veya Markets listesindeki
uygun varsayılan coin detayına yönlendirir.

## 6. Asset Detail Screen — FINAL STITCH

Kaynak:
Güncellenmiş Market / Limit işlem terminali.

Bu ekran önceki yalnızca Market tasarımının
yerini alır.

### 6.1 Ekran Hiyerarşisi

AssetDetailScreen
 ├─ Top Bar
 ├─ Asset Quick Bar
 ├─ Price Summary Card
 ├─ Virtual Trading Panel
 │   ├─ Başlık
 │   ├─ AL / SAT
 │   ├─ Market / Limit
 │   ├─ Bakiye
 │   ├─ Conditional Inputs
 │   ├─ Percent Shortcuts
 │   ├─ Calculation Summary
 │   └─ Confirm Action
 ├─ Price Chart
 ├─ Order Book / Live Trades
 └─ Demo Risk Card

### 6.2 Top Bar

- Geri ikonu
- Varlık Detayı & Emir Terminali
- Uygulama avatarı veya marka

### 6.3 Asset Quick Bar

- BTC / USDT
- SPOT L2 görünümü
- Bitcoin adı
- Favori yıldızı
- Alarm ikonu

Coin değişirse başlık ve bütün veriler değişir.

SPOT L2 tasarım etiketidir.
Gerçek bağlantı statüsü değildir.

"Bitcoin Gerçek Zamanlı" gibi ibareler
mock sürümde "Bitcoin / Demo Veri" olarak gösterilir.

### 6.4 Price Summary

- Spot Gösterge Fiyatı
- Büyük güncel fiyat
- 24s mutlak değişim
- 24s yüzde değişim
- 24s Yüksek
- 24s Düşük
- 24s Hacim

Tasarımda:
67,842.50
+3.79%

gibi örnek değerler kullanılmıştır.

Uygulamadaki fiyatları ortak mock state'ten al.

### 6.5 Virtual Trading Panel

Burası son güncellenmiş Stitch tasarımıdır.

Tasarım sırası:

Simüle Alım-Satım
├─ Risksiz Sanal İşlem
├─ AL (BUY) / SAT (SELL)
├─ Emir Tipi
│  ├─ Piyasa (Market)
│  └─ Limit Emri
├─ Kullanılabilir Sanal Bakiye
├─ Koşullu Hedef Limit Fiyatı
├─ İşlem Tutarı / Miktar
├─ Giriş Birimi: USDT ⇄ BTC
├─ 25% / 50% / 75% / 100%
├─ Tahmini Kripto Miktarı
├─ Gösterge / Gerçekleşme Fiyatı
├─ Toplam İşlem Değeri
├─ Simüle Komisyon
├─ Limit Bilgilendirme Metni
└─ İşlem Butonu

### 6.6 AL / SAT

AL seçildiğinde:
- Yeşil seçili durum
- Kullanılabilir sanal USDT bakiye
- Buy formu
- Yeşil onay butonu

SAT seçildiğinde:
- Kırmızı seçili durum
- Kullanılabilir coin miktarı
- Sell formu
- Kırmızı onay butonu

AL ve SAT aynı trading panelinin içindedir.

### 6.7 Market Modu

Varsayılan emir türü Market.

Başlık:
"Piyasa (Market)"

Açıklama:
"Anlık Piyasa Fiyatı"

Göster:
- Bakiye
- İşlem tutarı alanı
- Giriş Birimi: USDT ⇄ BTC
- 25% / 50% / 75% / 100%
- Tahmini Kripto Miktarı
- Gösterge / Gerçekleşme Fiyatı
- Toplam İşlem Değeri
- Simüle Komisyon
- Demo işlem butonu

Gösterme:
- Hedef Limit Fiyatı

USDT giriş modunda:
Girilen tutar baz alınır.

BTC giriş modunda:
Girilen miktar baz alınır.

Tahmini işlem fiyatı:
Buy -> mock ask
Sell -> mock bid

Market işlemi:
Onaylanınca ortak demo state güncellenir.

### 6.8 Limit Modu

Başlık:
"Limit Emri"

Göster:
- Hedef Limit Fiyatı (USDT)
- Güncel Fiyatı Kullan
- BTC Miktarı
- 25% / 50% / 75% / 100%
- Toplam İşlem Değeri
- Simüle Komisyon
- Limit bilgilendirme metni
- Limit emir onay butonu

Hedef limit fiyatı kullanıcı tarafından
düzenlenebilir.

"Güncel Fiyatı Kullan":
Mock referans fiyatını inputa doldurur.

Limit modunda:
USDT ⇄ BTC giriş birimi değiştirici gösterilmez.

Toplam:
limitPrice * quantity

Açıklama:
"Emriniz belirlediğiniz fiyat veya daha
avantajlı bir fiyat oluştuğunda gerçekleşebilir."

Buton:
"Limit Alış Emri Oluştur"
veya
"Limit Satış Emri Oluştur"

Bu aşamada Limit emri mock state'e
bekleyen emir olarak eklenir.

Otomatik eşleştirme motoru yazılmaz.

### 6.9 Trading Form Flutter Örneği

Bu bileşen görsel ve UI durum geçişlerini gösterir.
Demo işlem state'i ayrıca bağlanmalıdır.

```dart
import 'package:flutter/material.dart';

enum TradeSide { buy, sell }
enum OrderType { market, limit }

class TradingForm extends StatefulWidget {
  const TradingForm({super.key});

  @override
  State<TradingForm> createState() =>
      _TradingFormState();
}

class _TradingFormState extends State<TradingForm> {
  TradeSide side = TradeSide.buy;
  OrderType type = OrderType.market;

  final priceController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<TradeSide>(
          segments: const [
            ButtonSegment(
              value: TradeSide.buy,
              label: Text('AL'),
            ),
            ButtonSegment(
              value: TradeSide.sell,
              label: Text('SAT'),
            ),
          ],
          selected: {side},
          onSelectionChanged: (value) {
            setState(() => side = value.first);
          },
        ),
        const SizedBox(height: 16),
        const Text('Emir Tipi'),
        SegmentedButton<OrderType>(
          segments: const [
            ButtonSegment(
              value: OrderType.market,
              label: Text('Piyasa (Market)'),
            ),
            ButtonSegment(
              value: OrderType.limit,
              label: Text('Limit Emri'),
            ),
          ],
          selected: {type},
          onSelectionChanged: (value) {
            setState(() => type = value.first);
          },
        ),
        const SizedBox(height: 16),
        if (type == OrderType.limit) ...[
          TextField(
            controller: priceController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Hedef Limit Fiyatı (USDT)',
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: amountController,
          keyboardType:
              const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            labelText: type == OrderType.market
                ? 'İşlem Tutarı / Miktarı'
                : 'Miktar (BTC)',
          ),
        ),
      ],
    );
  }
}
```

Bu sadece minimum yapı örneğidir.

Tam implementasyonda:
- Bakiye
- Giriş birimi
- Yüzde kısayolları
- Güncel Fiyatı Kullan
- Komisyon
- Tahmini miktar
- İşlem özeti
- Doğrulama
- Onay butonu

eklenmelidir.

### 6.10 Trade Confirmation

Market:
- Onay bottom sheet
- İşlem yönü
- Coin
- Miktar
- Tahmini fiyat
- Toplam
- Demo uyarısı
- Onay

Başarılı olunca:
"Piyasa emri başarıyla simüle edildi."

Limit:
- Emir özeti
- Hedef fiyat
- Miktar
- Toplam
- Onay
- "Emir Bekliyor" durumu

Limit emri Portföy -> Bekleyen Emirler'e eklenir.

### 6.11 Chart Section

Stitch kontrolleri:

Periyotlar:
- 1S
- 1G
- 1H
- 1A
- Tümü

Grafik tipleri:
- Mum
- Çizgi

Göstergeler:
- MA(7)
- MA(25)

Diğer alanlar:
- Fiyat ekseni
- Zaman ekseni
- Hacim çubukları

Periyot seçilince mock chart datası değişir.
Gerçek API isteği gönderilmez.

### 6.12 Order Book / Live Trades

İki tab vardır:

1. Emir Defteri (Order Book)
2. Canlı İşlemler (Live Trades)

Emir Defteri:
- Ask fiyatları kırmızı
- Bid fiyatları yeşil
- Fiyat (USDT)
- Miktar (BTC)
- Toplam
- Son fiyat
- Spread
- Derinlik çubukları

Canlı İşlemler:
- Zaman
- Yön
- Fiyat
- Boyut

AL -> Yeşil
SAT -> Kırmızı

Veriler mock'tur.

Demo kullanıcının kendi işlemleri
Canlı İşlemler listesine eklenmez.

Kendi işlemleri Portföy işlem geçmişindedir.

### 6.13 Risk Information

Kart başlığı:
"Sıfır Riskli Alıştırma"

Açıklama:
"Bu sürümde piyasa verileri örnektir.
Tüm alım-satım işlemleri sanaldır ve
gerçek para kullanılmaz."

## 7. Portfolio Screen

Kaynak:
Portföy Sanal Bakiye Varlık Dağılımı

### Ekran Hiyerarşisi

PortfolioScreen
├─ Header
├─ Toplam Sanal Servet
├─ Günlük P/L
├─ Kullanılabilir Nakit
├─ Portföy Aksiyonları
├─ Varlık Dağılımı
├─ Varlıklarım
├─ Son İşlem Geçmişi
├─ Bekleyen Emirler
└─ Performans İstatistikleri

### 7.1 Header

- Aether Portfolio
- Sanal Portföyüm
- Simülasyon Modu
- Bildirim ikonu

### 7.2 Summary

Stitch düzeni:
- Büyük toplam bakiye
- Toplam getiri
- Yüzdelik değişim
- Günlük P/L
- Kullanılabilir nakit

Başlangıç:
100.000 TL sanal sermaye.

Stitch'in 78.450,80 USDT gibi rakamlarını
sabit uygulama bakiyesi olarak kullanma.

### 7.3 Portfolio Actions

- Sıfırla
- Rapor / İstatistikler

Stitch'teki "Para Ekle" tasarımı
zorunlu ürün davranışı değildir.

Kontrolsüz yeni demo bakiye üretme.

### 7.4 Allocation

Donut chart.

Dilimler:
- BTC
- ETH
- SOL
- Nakit

Tüm oranların toplamı %100 olmalı.

### 7.5 Holdings

Başlık:
"Varlıklarım"

Satır:
- Coin icon
- Symbol
- Sahip olunan miktar
- Ortalama alış
- Güncel değer
- Kâr/zarar
- Getiri yüzdesi

Sıralama:
- Değere Göre
- Kâra Göre
- İsme Göre

### 7.6 Recent Transactions

Satır:
- Alış/satış yönü
- Coin
- Tarih/saat
- Birim fiyat
- Miktar
- Demo durumu

### 7.7 Pending Orders

- İşlem çifti
- AL / SAT
- Limit fiyatı
- Miktar
- Toplam
- Bekliyor
- İptal et

Emir iptali mock state'i günceller.

### 7.8 Performance

- İşlem sayısı
- Gerçekleşmiş kâr/zarar
- Gerçekleşmemiş kâr/zarar
- Kârlı işlem oranı
- En iyi / en kötü tamamlanan işlemler

## 8. Profile Screen

Stitch'te ayrı bir profil ekranı bulunmuyor.

Aynı tasarım diliyle oluştur.

Alanlar:
- Demo kullanıcı avatarı
- Profil bilgisi
- Tema seçimi
- TRY / USDT görünümü
- Bildirim tercihleri
- Fiyat alarmları
- Portföy sıfırlama
- Hakkında

Gerçek kullanıcı servisi yok.

## 9. Alerts UI

Fiyat alarmı oluşturma:
- Coin
- Hedef fiyat
- Üstüne çıkınca
- Altına inince
- Kaydet

Kaydedilen mock alarmlar:
- Listelenir
- Düzenlenir
- Silinir
- Açılır/kapatılır

Push notification gönderme.

## 10. Bottom Navigation

Üç ana sekme:

Piyasalar
Portföy
Profil

Flutter örneği:

```dart
NavigationBar(
  selectedIndex: selectedIndex,
  onDestinationSelected: onTabSelected,
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.candlestick_chart),
      label: 'Piyasalar',
    ),
    NavigationDestination(
      icon: Icon(Icons.pie_chart_outline),
      label: 'Portföy',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      label: 'Profil',
    ),
  ],
)
```

Kripto Detay ayrı route olabilir.

AL / SAT, Market / Limit ve Order Book / Trades
ekran içi state ile yönetilir.

## 11. Kabul Kriterleri

- Bütün ekranlar var.
- Tasarım kimliği korunuyor.
- Navigasyon çalışıyor.
- Arama / favoriler çalışıyor.
- Market / Limit alanları koşullu.
- Demo işlem onayı var.
- Portföy state'i tutarlı.
- Mock grafikler görüntüleniyor.
- Emir Defteri / Canlı İşlemler tabları çalışıyor.
- Ekran taşması yok.
- Gerçek API/backend yok.
