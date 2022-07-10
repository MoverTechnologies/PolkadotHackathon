import 'package:flutter/material.dart';
import 'package:mover/app/common/repositories/web3_repository.dart';
import 'package:mover/app/pages/connect_wallet/views/connect_wallet_view.dart';

import 'app/pages/auth/views/signin_view.dart';
import 'app/pages/wallet/views/import_wallet_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Web3Repository().hasPrivateKey)
        ? const SignInView()
        : const ConnectWalletView();
  }
}
