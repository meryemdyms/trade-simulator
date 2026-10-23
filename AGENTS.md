
# AETHER CRYPTO — AGENT RULES

## 1. Dosya Okuma

Her göreve başlamadan önce:
1. project.md oku.
2. Görevle ilgili SKILL.md dosyalarını oku.
3. Etkilenen Flutter feature'larını belirle.
4. Kısa uygulama planı oluştur.
5. Ardından görevi gerçekleştir.

Skill kullanım koşulları kendi YAML description
alanlarında tanımlıdır.

Birden fazla skill birlikte kullanılabilir.

## 2. Kesin Sınır

SADECE FLUTTER UI.

YASAK:
- Backend
- REST API çağrısı
- WebSocket bağlantısı
- Firebase / Supabase
- Veritabanı
- HTTP / Dio client
- Gerçek authentication
- Gerçek Binance order işlemi
- Sunucu uygulaması
- Gerçek push notification

API sözleşmelerini ağ isteği yazma talimatı
olarak yorumlama.

## 3. Tasarım Kaynağı

Mevcut Aether Crypto Stitch tasarımı korunacak.

Tasarım:
flutter-design-system/SKILL.md

Ekran düzeni:
flutter-screen-builder/SKILL.md

Mock etkileşimler:
flutter-mock-interactions/SKILL.md

Veri alanları:
binance-ui-contracts/SKILL.md

Harici ZIP, HTML veya ekran görüntüsü bekleme.

Markdown dosyalarındaki tanımları kaynak kabul et.

## 4. Güncel Trading Tasarımı

Son tasarım:
AL / SAT
+
Market / Limit

Bu kombinasyonu koru.

Market:
- USDT/BTC giriş birimi seçimi
- Anlık piyasa fiyatı
- Tahmini miktar
- Demo işlem onayı

Limit:
- Hedef Limit Fiyatı
- Güncel Fiyatı Kullan
- Kripto miktarı
- Toplam tutar
- Bekleyen emir açıklaması

Eski yalnızca Market tasarımına geri dönme.

## 5. Mimari

Feature-first yapı kullan.

Tekrarlanan widget'ları ortaklaştır.

Yerel state için ValueNotifier veya ChangeNotifier kullan.

Widget build içinde ağır hesaplamalar veya
asenkron işlemler oluşturma.

Mock veri ve görsel sunumu ayır.

Gereksiz abstraction oluşturma.

## 6. Veri Tutarlılığı

Tek ortak demo state kaynağı oluştur.

Aynı coin fiyatı tüm ekranlarda tutarlı olmalı.

Favoriler, bakiye, emirler ve portföy
ortak state üzerinden güncellenmeli.

Gerçek para ve demo para karıştırılmamalı.

Gerçek canlı piyasa varmış gibi gösterme.

## 7. Değişiklik Kuralları

Yalnızca görevle ilgili dosyaları değiştir.

Yeni dosya oluşturursan:
- Importları düzenle.
- Route bağlantılarını yap.
- State bağımlılıklarını bağla.
- Gerektiğinde test ekle.

Kullanıcı istemedikçe:
- Marka değiştirme.
- Renk paleti değiştirme.
- Yeni ana tab ekleme.
- Teknoloji veya mimariyi değiştirme.
- Backend ekleme.

## 8. UI Kalitesi

- Stitch renklerini kullan.
- Inter veya uygun fallback kullan.
- Finansal sayıları okunabilir tut.
- Kompakt mobil liste yapısını koru.
- Yatay ve dikey taşma oluşturma.
- SafeArea kullan.
- Boş ve hata durumlarını tasarla.
- Her görünür kontrol gerçek mock UI davranışı sunsun.

## 9. Kontroller

Görev sonunda mümkünse:
- dart format .
- flutter analyze
- flutter test

Kontrolleri gerçekten çalıştırmadıysan
çalıştırılmış gibi raporlama.

## 10. Raporlama

Görev sonunda belirt:
- Tamamlanan ekranlar / özellikler
- Oluşturulan dosyalar
- Değiştirilen dosyalar
- Çalışan mock etkileşimler
- Test sonuçları
- Bilinen eksikler

Kendi başına sonraki API entegrasyonu aşamasına geçme.
