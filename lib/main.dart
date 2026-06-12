import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/services/secure_storage.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final token = await SecureStorageService.getToken();
  final initialRoute = token != null ? AppRouter.dashboard : AppRouter.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'Skena.id App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
