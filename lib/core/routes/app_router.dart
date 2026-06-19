import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/product_detail_page.dart';
import '../../features/dashboard/data/models/product_model.dart';
import '../../features/dashboard/presentation/pages/splash_page.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/data/models/order_model.dart';
import '../../features/order/presentation/pages/order_success_page.dart';
import '../../features/order/presentation/pages/my_order_page.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String productDetail = '/product-detail';
  static const String splash = '/splash';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String paymentPending = '/payment-pending';
  static const String myOrders = '/my-orders';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case productDetail:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailPage(product: product),
        );
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutPage());

      case orderSuccess:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: OrderSuccessPage(order: order)),
        );

      case paymentPending:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Menunggu Pembayaran untuk Order #${order.id}'),
            ),
          ),
        );

      case myOrders:
        return MaterialPageRoute(builder: (_) => const MyOrdersPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} tidak ditemukan')),
          ),
        );
    }
  }
}