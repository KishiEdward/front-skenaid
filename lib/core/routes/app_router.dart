import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pastikan import file-file page dan provider kamu sudah benar sesuai lokasinya
import '../../core/services/secure_storage.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dashboard/presentation/pages/product_detail_page.dart';
import '../../features/dashboard/data/models/product_model.dart';
import '../../features/order/presentation/pages/checkout_page.dart';
import '../../features/order/data/models/order_model.dart';
import '../../features/order/presentation/pages/order_success_page.dart';
import '../../features/order/presentation/pages/my_order_page.dart';
import '../../features/order/presentation/pages/order_detail_page.dart';
import '../../features/order/presentation/pages/payment_pending_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String paymentPending = '/payment-pending';
  static const String myOrders = '/my-orders';
  static const String orderDetail = '/order-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());

      case productDetail:
        final args = settings.arguments;
        if (args is ProductModel) {
          return MaterialPageRoute(builder: (_) => ProductDetailPage(product: args));
        }
        return _errorRoute('Data produk tidak ditemukan');

      case paymentPending:
        final args = settings.arguments;
        if (args is OrderModel) {
          return MaterialPageRoute(builder: (_) => PaymentPendingPage(order: args));
        }
        return _errorRoute('Data pesanan tidak ditemukan');

      case orderSuccess:
        final args = settings.arguments;
        if (args is OrderModel) {
          return MaterialPageRoute(builder: (_) => OrderSuccessPage(order: args));
        }
        return _errorRoute('Data pesanan tidak ditemukan');

      case orderDetail:
        final args = settings.arguments;
        if (args is OrderModel) {
          return MaterialPageRoute(builder: (_) => OrderDetailPage(order: args));
        }
        return _errorRoute('Data pesanan tidak ditemukan');

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case cart:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: CartPage()));
      case checkout:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: CheckoutPage()));
      case myOrders:
        return MaterialPageRoute(builder: (_) => const AuthGuard(child: MyOrdersPage()));

      // ─── RUTE TIDAK DIKENAL ───────────────────────────────────────
      default:
        return _errorRoute('Halaman ${settings.name} tidak ditemukan');
    }
  }

  // Fungsi bantuan untuk menampilkan halaman error jika argumen gagal dilempar
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}

// =====================================================================
// CLASS PENDUKUNG TETAP ADA DI SINI ATAU DI FILE TERPISAH
// =====================================================================

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;
    return switch (status) {
      AuthStatus.authenticated => child,
      AuthStatus.emailNotVerified => const VerifyEmailPage(),
      // Jika loading, cegah agar tidak langsung mental ke LoginPage
      AuthStatus.initial || AuthStatus.loading => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      _ => const LoginPage(),
    };
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final token = await SecureStorageService.getToken();
    if (!mounted) return;
    final route = token != null ? AppRouter.dashboard : AppRouter.login;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}