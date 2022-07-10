import 'package:flutter/material.dart';
import 'package:mover/app/pages/welcome/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/import_wallet_provider.dart';

class ImportWalletView extends StatefulWidget {
  const ImportWalletView({Key? key}) : super(key: key);

  @override
  State<ImportWalletView> createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends State<ImportWalletView> {
  String? _errMsg;
  Icon _icon = const Icon(
    Icons.key,
    color: Colors.amber,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            AppLocalizations.of(context)!.importYourWallet,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: FittedBox(
              child: Text(
                AppLocalizations.of(context)!.importYourWalletNotice,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.privateKey,
                prefixIcon: _icon,
                errorText: _errMsg,
              ),
              maxLength: 64,
              autofocus: true,
              onTap: () {
                setState(() {
                  _errMsg = null;
                });
              },
              onChanged: _import,
              onSubmitted: _import,
            )),
      ],
    )));
  }

  _import(String _text) async {
    if (await context.read<ImportWalletProvider>().importWallet(_text)) {
      print("success");
      setState(() {
        _errMsg = null;
        _icon = Icon(
          Icons.check,
          color: Colors.green,
        );
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
        (route) => false,
      );
    } else {
      print("fail");
      setState(() {
        _errMsg = AppLocalizations.of(context)!.invalidPrivateKey;
      });
    }
  }
}
