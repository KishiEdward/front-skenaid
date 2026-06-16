class ApiConstants {
  static const String baseUrl = 'http://10.205.91.113:8080/v1';

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;

  // Endpoints untuk fitur keranjang dan pesanan
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String checkout = '/orders/checkout';
}
