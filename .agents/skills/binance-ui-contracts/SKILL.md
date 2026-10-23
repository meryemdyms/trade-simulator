
---
name: binance-ui-contracts
description: Binance Spot REST ve WebSocket alanlarının Flutter mock modellerine, fiyat etiketlerine, grafiklere, emir defterine, piyasa işlemlerine ve sanal trading alanlarına eşlenmesi gerektiğinde kullan. Gerçek API bağlantısı yapmaz.
---

# BINANCE UI CONTRACTS

## 1. Amaç

Bu dosya gelecekte kullanılacak
Binance Spot API veri sözleşmelerini tanımlar.

Şimdiki görev:
Bu sözleşmelere uygun Flutter UI
ve mock modeller oluşturmak.

GERÇEK REST ÇAĞRISI YOK.
GERÇEK WEBSOCKET YOK.
BACKEND YOK.

Referans:
Binance Spot API resmi dokümantasyonu.

## 2. Exchange Info

REST:
GET /api/v3/exchangeInfo

Örnek:

```json
{
  "symbol": "BTCUSDT",
  "status": "TRADING",
  "baseAsset": "BTC",
  "quoteAsset": "USDT",
  "isSpotTradingAllowed": true,
  "orderTypes": ["MARKET", "LIMIT"]
}
```

Alan -> UI

symbol:
İşlem çifti ID.
Örnek BTCUSDT.

baseAsset:
Kripto sembolü.
Örnek BTC.

quoteAsset:
Fiyatlandırma birimi.
Örnek USDT.

status:
İşlem durumu.
Örnek TRADING.

isSpotTradingAllowed:
Spot işlemlere uygunluk.

orderTypes:
Desteklenen Binance emir tipleri.

filters:
İşlem hassasiyeti ve gerçek piyasa kuralları.

Varsayılan liste filtresi:
quoteAsset == USDT
status == TRADING
isSpotTradingAllowed == true

Önemli:
exchangeInfo tam kripto adı veya
coin logo URL'si vermez.

Coin adı / logo:
Yerel mock metadata.

## 3. 24hr Ticker

REST:
GET /api/v3/ticker/24hr

```json
{
  "symbol": "BTCUSDT",
  "lastPrice": "67840.50",
  "priceChange": "2480.20",
  "priceChangePercent": "3.79",
  "highPrice": "68450.00",
  "lowPrice": "65120.00",
  "volume": "12500",
  "quoteVolume": "840000000"
}
```

Alan -> UI:

symbol:
Market listesi ilişkilendirme anahtarı.

lastPrice:
Ana Sayfa fiyat.
Detay fiyatı.

priceChange:
24s mutlak değişim.

priceChangePercent:
Ana Sayfa 24s yüzde.
Detay 24s yüzde.

highPrice:
24s yüksek.

lowPrice:
24s düşük.

volume:
Baz varlık hacmi.

quoteVolume:
Kotasyon birimi hacmi.

24 saatlik yüzde:
Kullanıcının portföy getirisi değildir.

## 4. Klines

REST:
GET /api/v3/klines

Örnek mum:

```json
[
  [
    1710000000000,
    "67800.00",
    "68300.00",
    "67600.00",
    "68100.00",
    "125.50",
    1710003599999,
    "8530000.00",
    1200,
    "63.50",
    "4310000.00",
    "0"
  ]
]
```

Indexler:

[0] Open Time
[1] Open
[2] High
[3] Low
[4] Close
[5] Volume
[6] Close Time

UI:
- Candlestick
- Line chart
- Volume
- MA(7)
- MA(25)
- Chart time labels

Stitch zaman aralıkları:
1S, 1G, 1H, 1A, Tümü.

Bu görünüm aralıkları ile API'nin
mum interval parametresi aynı şey değildir.

Gerçek entegrasyonda interval ve
veri sayısı ayrıca belirlenir.

## 5. Depth

REST:
GET /api/v3/depth

```json
{
  "lastUpdateId": 1027024,
  "bids": [
    ["67840.00", "0.500"],
    ["67835.00", "1.200"]
  ],
  "asks": [
    ["67845.00", "0.400"],
    ["67850.00", "0.900"]
  ]
}
```

lastUpdateId:
Snapshot eşleştirme alanı.
UI'da gösterilmez.

bids:
Bekleyen alış emirlerinin
fiyat seviyeleri.

asks:
Bekleyen satış emirlerinin
fiyat seviyeleri.

Her kayıt:
[0] Fiyat
[1] Miktar

UI:
Asset Detail -> Emir Defteri

Bid:
Yeşil.

Ask:
Kırmızı.

Spread:
BestAsk - BestBid.

Depth kişi sayısı göstermez.
Fiyat seviyesindeki toplam miktarı gösterir.

## 6. Trades

REST:
GET /api/v3/trades

```json
[
  {
    "id": 12345,
    "price": "67842.50",
    "qty": "0.1420",
    "quoteQty": "9634.00",
    "time": 1710000000000,
    "isBuyerMaker": false,
    "isBestMatch": true
  }
]
```

Alan -> UI:

price:
Gerçekleşen işlem fiyatı.

qty:
İşlem miktarı.

time:
İşlem saati.

isBuyerMaker:
false -> agresif alış
true -> agresif satış

Bu alan alıcı/satıcı kimliğini göstermez.
Her işlemde hem alıcı hem satıcı vardır.

UI:
Asset Detail -> Canlı İşlemler

Bu veri kullanıcının demo işlem geçmişi değildir.

## 7. Book Ticker

REST:
GET /api/v3/ticker/bookTicker

```json
{
  "symbol": "BTCUSDT",
  "bidPrice": "67840.00",
  "bidQty": "0.500",
  "askPrice": "67845.00",
  "askQty": "0.400"
}
```

bidPrice:
En iyi alış fiyatı.

bidQty:
En iyi alış seviyesindeki miktar.

askPrice:
En iyi satış fiyatı.

askQty:
En iyi satış seviyesindeki miktar.

UI:
Asset Detail -> Sanal Al/Sat

Market AL:
Ask referans fiyatı.

Market SAT:
Bid referans fiyatı.

Tek en iyi fiyat seviyesi her büyüklükte
emri karşılayamayabilir.

Gerçekçi büyük emir simülasyonunda
depth kullanımı ileride değerlendirilecektir.

## 8. Ticker Price

REST:
GET /api/v3/ticker/price

```json
{
  "symbol": "BTCUSDT",
  "price": "67840.50"
}
```

symbol:
İşlem çifti.

price:
Son gerçekleşen işlem fiyatı.

UI:
- Portföy güncel pozisyon değeri
- Varlık fiyat referansı

Bu fiyat ticker/24hr'dan da alınabilir.

Gereksiz kopya veri state'i oluşturma.

## 9. WebSocket Contracts

Bu akışlar gelecekteki
gerçek zamanlı veri entegrasyonu içindir.

Şimdilik:
STREAM BAĞLANTISI AÇMA.

### 9.1 All Market Ticker

Stream:
!ticker@arr

Alanlar:
s -> symbol
c -> last price
P -> 24h change percentage
h -> high price
l -> low price
v -> volume
q -> quote volume

UI:
Piyasalar listesi.

Gelen mesajlar tüm çiftleri zorunlu
olarak içermeyebilir.

Symbol üzerinden mevcut kayıt güncellenir.

### 9.2 Single Asset Ticker

Stream:
btcusdt@ticker

s -> symbol
c -> last price
P -> 24h percentage
h -> high
l -> low
v -> volume

UI:
Detay fiyat özeti.

### 9.3 Mini Ticker

Stream:
!miniTicker@arr

MiniTicker doğrudan P alanını vermez.

24 saatlik değişimi doğrudan
göstermek için ticker akışı daha uygundur.

### 9.4 Kline

Stream:
btcusdt@kline_1m

Önemli alanlar:

k.t -> open time
k.o -> open
k.h -> high
k.l -> low
k.c -> close
k.v -> volume
k.x -> candle closed

UI:
Grafikte güncel mum.

### 9.5 Depth Snapshot Stream

Stream:
btcusdt@depth20@100ms

UI:
İlk 20 seviye emir defteri.

Alternatif:
btcusdt@depth@100ms

Alternatif diff stream'de REST snapshot
ve WebSocket güncellemeleri sıralı şekilde
senkronize edilmelidir.

Bu UI aşamasında bu mantığı yazma.

### 9.6 Trade Stream

Stream:
btcusdt@trade

p -> price
q -> quantity
T -> trade time
m -> buyer maker flag

m == false:
Agresif alış.

m == true:
Agresif satış.

UI:
Canlı İşlemler.

### 9.7 BookTicker Stream

Stream:
btcusdt@bookTicker

s -> symbol
b -> bid price
B -> bid qty
a -> ask price
A -> ask qty

UI:
Market AL/SAT fiyat önizlemesi.

## 10. Ekran / Veri Kaynağı

| Ekran | REST | WebSocket |
|---|---|---|
| Piyasalar | exchangeInfo, ticker/24hr | !ticker@arr |
| Detay fiyat | ticker/24hr | symbol@ticker |
| Grafik | klines | symbol@kline |
| Emir Defteri | depth | symbol@depth20 |
| Canlı İşlemler | trades | symbol@trade |
| Sanal Market | bookTicker | symbol@bookTicker |
| Portföy | ticker/price | Ortak ticker state |

Bu tablo gelecekteki API tasarımını açıklar.

Flutter UI sürümünde bu verilerin
tamamı mock fixture'lardan gelir.

## 11. Flutter UI Model Mapping

MarketAsset:
- symbol
- baseAsset
- quoteAsset
- name
- price
- change24h
- high24h
- low24h
- volume
- quoteVolume
- bidPrice
- askPrice

Candle:
- openTime
- open
- high
- low
- close
- volume

OrderBookLevel:
- price
- quantity

MarketTrade:
- id
- price
- quantity
- time
- isBuyerMaker

VirtualOrder:
- id
- symbol
- side
- type
- quantity
- price
- status
- createdAt

PortfolioHolding:
- asset
- quantity
- averageCost
- currentPrice

## 12. Ekran Veri Durumları

Mock UI durumları:
- Initial
- Loading
- Data
- Empty
- Error
- Stale
- Disconnected

Gerçek bağlantı kurulmadığından:
"Canlı bağlantı başarılı" gibi
gerçek dışı durum gösterme.

## 13. Gerçek API Öncesi Kritik Noktalar

Bu sürümde uygulanmayacak,
ileride dikkate alınacak:

- API rate limits
- Reconnect
- WebSocket lifecycle
- Data freshness
- Depth sequence synchronization
- Decimal precision
- Real currency conversions
- Server-backed limit order execution
- Historical data reconciliation

Bu maddeleri gördüğünde
entegrasyon kodu yazma.

## 14. Kesin Sınır

YALNIZCA:
- Veri alanlarının modellenmesi
- Mock veri eşleştirmesi
- Flutter ekranlarında sunum
- UI state davranışları

YASAK:
- HTTP bağlantısı
- WebSocket bağlantısı
- Gerçek emir
- API authentication
- Backend
- Veritabanı
