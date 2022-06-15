import 'package:flutter/material.dart';
import 'package:mover/app/common/providers/wallet_provider.dart';
import 'package:mover/app/pages/signin/views/signin_view.dart';
import 'package:mover/app/pages/welcome/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shimmer/shimmer.dart';

class ConnectWalletView extends StatelessWidget {
  const ConnectWalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage(getAssetPath("header-background.jpg")),
              //   fit: BoxFit.cover,
              // ),
              ),
        ),
        Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              FittedBox(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "MOVER",
                      style: Theme.of(context).textTheme.headline2,
                    )),
              ),
              TextButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 206, 219, 26),
                          Color.fromARGB(255, 113, 211, 34)
                        ],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                      ),
                    ),
                    child: Shimmer.fromColors(
                        baseColor: Color.fromARGB(255, 102, 102, 102),
                        highlightColor: Color.fromARGB(255, 187, 187, 187),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.connectWallet,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        )),
                  ),
                  onPressed: (context
                          .select((WalletProvider _model) => _model.inProgress))
                      ? null
                      : () async {
                          context
                              .read<WalletProvider>()
                              .startConnect(context)
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WelcomeView()),
                                (route) => false);
                          }, onError: (e) {
                            _showYesDialog(context,
                                AppLocalizations.of(context)!.connectWallet, e);
                          });
                        }),
            ]))
      ],
    ));
  }

  Future<void> _showYesDialog(
      BuildContext context, String _title, String _body) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_body),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
