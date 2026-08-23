class ApiConstants {
  // للاتصال بـ Laravel من محاكي Android استخدم 10.0.2.2
  // إذا كنت تختبر على هاتف حقيقي، ضع الـ IP الخاص بجهاز الكمبيوتر في الشبكة (مثال: 192.168.1.5)
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';

  // Devices Endpoints
  static const String devices = '/devices';
}