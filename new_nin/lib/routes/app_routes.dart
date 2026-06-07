import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/airtime/airtime_screen.dart';
import '../screens/data/data_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const airtime = '/airtime';
  static const data = '/data';
  static const wallet = '/wallet';
  static const history = '/history';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const DashboardScreen(),
    airtime: (context) => const AirtimeScreen(),
    data: (context) => const DataScreen(),
    wallet: (context) => const WalletScreen(),
    history: (context) => const HistoryScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
