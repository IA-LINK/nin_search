import 'package:flutter/material.dart';

import '../services/wallet_service.dart';

class WalletProvider extends ChangeNotifier {

  final WalletService _walletService =
      WalletService();

  WalletService get walletService =>
      _walletService;
}
