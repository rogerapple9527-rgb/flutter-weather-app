# Flutter Weather App

這個 App 會讓使用者輸入台灣縣市名稱，並查詢中央氣象署 `F-C0032-001` 的今明 36 小時天氣預報。

## 執行方式

先到中央氣象署 Open Data 平台申請授權碼：

- [https://opendata.cwa.gov.tw/index](https://opendata.cwa.gov.tw/index)

在專案目錄執行：

```bash
flutter pub get
```

Android emulator：

```bash
flutter run -d emulator-5554 --dart-define=CWA_AUTHORIZATION=your_api_key
```

iOS simulator：

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
flutter run -d "iPhone 13" --dart-define=CWA_AUTHORIZATION=your_api_key
```
