import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

import 'services/auth/auth_service.dart';
import 'services/wallet_service.dart';

import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/data/data_screen.dart';
import 'screens/wallet/fund_wallet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<WalletService>(create: (_) => WalletService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VTU App',

        // Initial screen
        home: const LoginScreen(),

        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const DashboardScreen(),
          '/history': (context) => const HistoryScreen(),
          '/data': (context) => const DataScreen(),
          '/fund-wallet': (context) => const FundWalletScreen(),
        },
      ),
    );
  }
}
