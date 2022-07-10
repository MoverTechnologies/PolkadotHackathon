import 'package:flutter/material.dart';
import 'package:mover/app/pages/auth/providers/sign_in_provider.dart';
import 'package:mover/app/pages/auth/views/signin_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VerifyCodeView extends StatefulWidget {
  VerifyCodeView({Key? key}) : super(key: key);

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  bool _onEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              AppLocalizations.of(context)!.validationCode,
              style: Theme.of(context).textTheme.headline4,
            )),
        SizedBox(
          height: 20,
        ),
        VerificationCode(
          textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
          keyboardType: TextInputType.number,
          underlineColor: Colors
              .amber, // If this is null it will use primaryColor: Colors.red from Theme
          length: 6,
          cursorColor:
              Colors.blue, // If this is null it will default to the ambient
          // clearAll is NOT required, you can delete it
          // takes any widget, so you can implement your design
          clearAll: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'clear all',
              style: TextStyle(
                  fontSize: 14.0,
                  decoration: TextDecoration.underline,
                  color: Colors.blue[700]),
            ),
          ),
          onCompleted: _verify,
          onEditing: (bool value) {
            setState(() {
              _onEditing = value;
            });
            if (!_onEditing) FocusScope.of(context).unfocus();
          },
        ),
      ])),
    ));
  }

  _verify(String _code) async {
    if (await context.read<SignInProvider>().verifyCode(_code)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignInView()));
    }
  }
}
