sealed class AppFailure {
  const AppFailure(this.message);

  final String message;
}

final class InvalidInputFailure extends AppFailure {
  const InvalidInputFailure([super.message = '請輸入有效的縣市名稱。']);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = '找不到該地區的天氣資料。']);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = '目前無法連線到天氣服務，請稍後再試。']);
}

final class ParsingFailure extends AppFailure {
  const ParsingFailure([super.message = '氣象資料格式不正確，無法解析。']);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = '系統發生未知錯誤，請稍後再試。']);
}
