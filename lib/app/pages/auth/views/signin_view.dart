import 'package:flutter/material.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignInView extends StatefulWidget {
  SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isFilledEmail = false;
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  AmplifyEndpoint _amplifyEndpoint = AmplifyEndpoint();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                TextField(
                  controller: _emailFieldController,
                  maxLength: 32,
                  autofillHints: [AutofillHints.username],
                  onSubmitted: (_text) {
                    setState(() {
                      _isFilledEmail = true;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search,
                    suffixIcon: IconButton(
                      onPressed: () => _emailFieldController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right_sharp),
                  onPressed: () {
                    setState(() {
                      _isFilledEmail = true;
                    });
                  },
                )
              ],
            ),
          ),
          if (_isFilledEmail)
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: _passwordFieldController,
                maxLength: 16,
                autofillHints: [AutofillHints.password],
                onSubmitted: (_text) async {
                  if (await _amplifyEndpoint.signin(SigninCredentials(
                      username: _emailFieldController.text.trim(),
                      password: _passwordFieldController.text.trim()))) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TopView()),
                        (route) => false);
                  }
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.search,
                  suffixIcon: IconButton(
                    onPressed: () => _passwordFieldController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.continueApp,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    )),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TopView()),
                    (route) => false);
              }),
        ]),
      ),
    );
  }
}
