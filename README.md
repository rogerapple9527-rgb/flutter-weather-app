# Flutter Weather App

這是一份依照 PDF 作業需求完成的 Flutter 面試作業，功能是查詢中央氣象署「一般天氣預報 - 今明 36 小時天氣預報」資料，並以 Clean Architecture 方式組織程式碼。

## 功能說明

- 輸入 `locationName` 查詢台灣縣市天氣預報
- 串接中央氣象署 `F-C0032-001`
- 顯示今明 36 小時預報資料
- 呈現 4 種狀態：初始、載入中、成功、錯誤
- 處理輸入無效與 API 資料格式異常

## 技術選型

- Flutter
- Riverpod
- Dio
- Clean Architecture

## 專案結構

```text
lib/
  app/
  core/
    constants/
    error/
    network/
    usecase/
  features/
    weather/
      data/
        datasources/
        mappers/
        models/
        repositories/
      domain/
        constants/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
        providers/
        states/
        widgets/
```

## 分層說明

- `presentation`：負責頁面、Widget、Riverpod 狀態管理、使用者互動
- `domain`：負責 Entity、Repository 抽象、Use Case
- `data`：負責 API 呼叫、DTO、資料轉換、Repository 實作

## API 說明

- API: `GET /v1/rest/datastore/F-C0032-001`
- 文件: [中央氣象署 Swagger](https://opendata.cwa.gov.tw/dist/opendata-swagger.html#/%E9%A0%90%E5%A0%B1/get_v1_rest_datastore_F_C0032_001)

授權碼支援以 `dart-define` 覆蓋：

```bash
--dart-define=CWA_AUTHORIZATION=your_api_key
```

本 repo 不會保存真實 API key。請到中央氣象署 Open Data 申請授權碼後，在執行時帶入：

- 申請位置：[中央氣象署 Open Data 平台](https://opendata.cwa.gov.tw/index)

程式讀取位置：

- [lib/core/constants/cwa_api_constants.dart](/Users/youting/flutter-weather-app/lib/core/constants/cwa_api_constants.dart)

## 執行方式

```bash
/opt/homebrew/share/flutter/bin/flutter pub get
/opt/homebrew/share/flutter/bin/flutter run --dart-define=CWA_AUTHORIZATION=your_api_key
```

例如 Android emulator：

```bash
/opt/homebrew/share/flutter/bin/flutter run -d emulator-5554 --dart-define=CWA_AUTHORIZATION=your_api_key
```

例如 iOS simulator：

```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
/opt/homebrew/share/flutter/bin/flutter run -d "iPhone 13" --dart-define=CWA_AUTHORIZATION=your_api_key
```

## 測試與檢查

```bash
/opt/homebrew/share/flutter/bin/flutter analyze
/opt/homebrew/share/flutter/bin/flutter test
```

## 錯誤處理策略

- 空字串輸入：提示使用者輸入有效縣市名稱
- 非台灣 22 縣市：直接視為無效輸入
- API 成功但查無資料：顯示錯誤狀態
- API 格式不正確：回傳解析錯誤
- 網路 timeout / connection error：回傳連線錯誤

## 作業完成對應

- 使用 Flutter 開發
- Android / iOS 可執行
- State Manager 使用 Riverpod，未使用 hooks
- API 串接使用 Dio
- README 已補充執行方式與架構說明

## 後續可延伸

- 補 repository / remote data source 測試
- 增加 UI 螢幕截圖或錄影
