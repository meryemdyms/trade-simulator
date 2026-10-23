
---
name: flutter-design-system
description: Flutter tema, renk, tipografi, spacing, kart, input, buton, grafik ve ortak tasarım widget'ları oluşturulurken veya düzenlenirken kullan. Aether Crypto Stitch tasarım kimliğini korur.
---

# FLUTTER DESIGN SYSTEM

## 1. Tasarım Kimliği

Marka: Aether Crypto

Stil:
- Premium dark fintech
- Modern finans terminali
- Minimal ve yüksek okunabilirlik
- Koyu lacivert arka plan
- Mikro sınırlı kartlar
- Yumuşak indigo vurgu
- Yeşil pozitif / AL
- Kırmızı-pembe negatif / SAT
- Kompakt veri satırları
- Hafif cam yüzey hissi
- Sade bottom navigation

Binance'in kalabalık ekran görünümünü kopyalama.

## 2. Renkler

Stitch DESIGN.md tokenları:

background: #0D1322
surfaceLowest: #080E1D
surfaceLow: #151B2B
surface: #191F2F
surfaceHigh: #242A3A
surfaceHighest: #2F3445

primary: #C0C1FF
primaryContainer: #8083FF

positive: #4AE176
negative: #FFB3AD

textPrimary: #DDE2F8
textSecondary: #C7C4D7

outline: #908FA0
outlineVariant: #464554

Bu değerleri tasarımın ana tokenları kabul et.

## 3. Flutter Color Constants

Dosya:
lib/app/theme/app_colors.dart

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF0D1322);
  static const surfaceLowest = Color(0xFF080E1D);
  static const surfaceLow = Color(0xFF151B2B);
  static const surface = Color(0xFF191F2F);
  static const surfaceHigh = Color(0xFF242A3A);
  static const surfaceHighest = Color(0xFF2F3445);

  static const primary = Color(0xFFC0C1FF);
  static const primaryContainer = Color(0xFF8083FF);

  static const positive = Color(0xFF4AE176);
  static const negative = Color(0xFFFFB3AD);

  static const textPrimary = Color(0xFFDDE2F8);
  static const textSecondary = Color(0xFFC7C4D7);

  static const outline = Color(0xFF908FA0);
  static const outlineVariant = Color(0xFF464554);
}
```

Diğer Flutter widget'larında doğrudan
renk sabiti hardcode etme.

## 4. Typography

Font: Inter

Stitch tipografi ölçüleri:

Display Balance:
38sp / w700 / line-height 44

Headline LG:
26sp / w600 / line-height 32

Headline MD:
20sp / w600 / line-height 26

Headline SM:
17sp / w600 / line-height 22

Body LG:
16sp / w400 / line-height 24

Body MD:
14sp / w400 / line-height 20

Body SM:
13sp / w400 / line-height 18

Numeric LG:
16sp / w600 / line-height 20

Numeric SM:
12sp / w600 / line-height 16

Caption:
11sp / w500 / line-height 14

Tüm finansal sayılarda tabular figures kullan.

Örnek:

```dart
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';

const financialTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  fontFeatures: [
    FontFeature.tabularFigures(),
  ],
);
```

Font dosyası mevcut değilse fallback kullan.
Harici font indirmeyi zorunlu tutma.

## 5. Flutter Theme

Dosya:
lib/app/theme/app_theme.dart

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.primary,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      error: AppColors.negative,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: scheme,
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.outlineVariant,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
```

## 6. Spacing

Temel ritim: 4dp.

4dp: micro
8dp: small
12dp: medium
16dp: standard
24dp: large
32dp: section

Ekran yatay padding:
16dp

Liste satırı:
12dp dikey / uygun yatay boşluk

Kart padding:
12–16dp

Büyük portföy kartı:
20–24dp

## 7. Border Radius

Small: 4dp
Default: 8dp
Medium: 12dp
Large: 16dp
XL: 24dp
Full: 999dp

## 8. Ortak AppCard

Dosya:
lib/core/widgets/app_card.dart

```dart
import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}
```

## 9. Butonlar

Primary:
- Rounded 12dp
- İndigo vurgu
- Yeterli kontrast
- 48dp minimum yükseklik

Buy:
- Positive green
- İşleme uygun yeşil ton
- Disabled durumunda muted görünüm

Sell:
- Negative red
- Aynı boyut ve hiyerarşi

Secondary:
- SurfaceHigh
- İnce outline
- Metin odaklı

Danger:
- Negatif işlem / sıfırlama

## 10. Trading Segmented Controls

AL / SAT:
- 2 eşit genişlik
- Seçili AL yeşil
- Seçili SAT kırmızı
- Seçilmemiş dark surface

Market / Limit:
- 2 eşit genişlik
- Seçili durum primary/indigo
- Market öncelikli
- Limit aynı görünüm hiyerarşisinde

Market'ten Limit'e geçiş:
- Koşullu form alanları değişir
- Kart ve ana ekran yerleşimi korunur

## 11. Piyasa Listesi

Her market row:
- Coin sembol alanı
- Coin adı
- 24s hacim
- Mini sparkline
- Fiyat
- 24s yüzde
- Favori

Sayısal fiyatlar sağa hizalanır.

Pozitif yüzde yeşil.
Negatif yüzde kırmızı.

## 12. Chart Design

- Dark background
- İnce grid
- Yeşil yükselen mum
- Kırmızı düşen mum
- Mum / Çizgi kontrolü
- Zaman seçici
- MA(7) ve MA(25) etiketleri
- Hacim çubukları
- Yatay eksen tarih/saat
- Dikey eksen fiyat

Grafikler mock fixture verilerini kullanır.

## 13. Order Book

Ask:
- Negative color
- Hafif kırmızı yoğunluk arka planı

Bid:
- Positive color
- Hafif yeşil yoğunluk arka planı

Kolonlar:
- Fiyat
- Miktar
- Toplam

Merkez:
- Son fiyat
- Spread

En iyi alış / satış ayrımı görünür olmalı.

## 14. Portfolio

Toplam bakiye büyük tipografi ile gösterilir.

Diğer kartlar:
- Günlük P/L
- Kullanılabilir nakit
- Varlık dağılımı
- Yatırım listesi
- İşlem geçmişi

Donut grafik:
- Tutarlı renkler
- Okunabilir açıklama
- Toplam %100

## 15. UI States

- Initial
- Loading
- Data
- Empty
- Error
- Stale
- Disconnected

Bu sürümde yalnızca mock durumlar gösterilir.

Canlı bağlantı varmış gibi status animasyonu yapma.

## 16. Responsive

375–430dp mobil genişliklerini temel al.

SafeArea kullan.

Uzun finansal değerlerde taşmayı önle.

Klavye açılınca form gizlenmemeli.

İçerik gerektiğinde kaydırılabilir olmalı.

Yatay grafik kaydırma desteklenebilir.

## 17. Animasyonlar

- Kısa splash
- Tab geçişi
- Buton basış geri bildirimi
- Mock loading skeleton
- İşlem onay görünümü

Aşırı glow, bounce veya hareketli dekorasyon kullanma.

## 18. Kesin Sınır

Bu skill yalnızca Flutter tasarımına aittir.

Gerçek API, WebSocket, backend veya
veritabanı oluşturmaz.
