import 'package:flutter/material.dart';
import 'package:mover/app/pages/connect_wallet/views/connect_wallet_view.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TopView();
    // return const ConnectWalletView();
  }
}
