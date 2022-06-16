import 'package:flutter/material.dart';
import 'package:mover/app/common/providers/wallet_provider.dart';
import 'package:mover/app/pages/connect_wallet/views/connect_wallet_view.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';
import 'package:provider/provider.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<WalletProvider>().isConnected) {
      return const TopView();
    } else {
      return const ConnectWalletView();
    }
  }
}
