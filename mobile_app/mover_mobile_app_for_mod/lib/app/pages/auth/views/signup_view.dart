import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/views/common_widget.dart';
import 'package:mover/app/pages/auth/views/signin_view.dart';
import 'package:mover/app/pages/auth/views/verify_code_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/sign_in_provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();
  bool _isSaveSignInInfo = false;

  String? _emailErrMsg;
  Icon _emailIcon = const Icon(
    Icons.email,
    color: Colors.grey,
  );

  String? _passwordErrMsg;
  Icon _passwordIcon = const Icon(
    Icons.password,
    color: Colors.grey,
  );
  bool _passwordVisible = false;
  final _passwordMinLength = 8;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 52.0),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.signUp,
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: _emailFieldController,
                          autofillHints: [AutofillHints.username],
                          onTap: () {
                            setState(() {
                              _emailIcon = const Icon(
                                Icons.email,
                                color: Colors.grey,
                              );
                              _emailErrMsg = null;
                            });
                          },
                          onChanged: _emailValidate,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.email,
                            prefixIcon: _emailIcon,
                            errorText: _emailErrMsg,
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: _passwordFieldController,
                          obscureText: !_passwordVisible,
                          maxLength: 16,
                          autofillHints: [AutofillHints.password],
                          onTap: () {
                            setState(() {
                              _passwordIcon = const Icon(
                                Icons.password,
                                color: Colors.grey,
                              );
                              _passwordErrMsg = null;
                            });
                          },
                          onSubmitted:
                              context.watch<SignInProvider>().inProgress
                                  ? null
                                  : (_text) async {
                                      _signUp;
                                    },
                          onChanged: _passwordValidate,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.password,
                              prefixIcon: _passwordIcon,
                              errorText: _passwordErrMsg,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              )),
                        )),
                    // TextButton(
                    //   child: Text(AppLocalizations.of(context)!.forgetYourPassword),
                    //   style: TextButton.styleFrom(
                    //       primary: Colors.black, alignment: Alignment.topRight),
                    //   onPressed: () {
                    //     showDialog(
                    //         builder: (context) => new SimpleDialog(
                    //                 title: Text(
                    //                     AppLocalizations.of(context)!
                    //                         .forgetYourPassword,
                    //                     style: TextStyle(fontSize: 12)),
                    //                 children: [
                    //                   ForgetPasswdView(),
                    //                   ElevatedButton(
                    //                     child: Text(
                    //                         AppLocalizations.of(context)!.cancel),
                    //                     onPressed: () {
                    //                       Navigator.pop(context, null);
                    //                     },
                    //                   ),
                    //                 ]),
                    //         context: context);
                    //   },
                    // ),
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInView()),
                              );
                            },
                            child: Text(
                                AppLocalizations.of(context)!
                                    .userHasAlreadyAccount,
                                style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.signInSaveInfoMsg,
                              style: TextStyle(fontSize: 12)),
                          Checkbox(
                            activeColor: Colors.blue,
                            value: _isSaveSignInInfo,
                            onChanged: (bool? value) {
                              setState(() {
                                _isSaveSignInInfo = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // Padding(
                //     padding: const EdgeInsets.only(left: 8.0),
                //     child: IconButton(
                //       iconSize: 70,
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       icon: CircleAvatar(
                //         radius: 50,
                //         backgroundColor: Colors.grey[400],
                //         child: const Icon(
                //           Icons.arrow_back,
                //           color: Colors.white,
                //           size: 30,
                //         ),
                //       ),
                //     )),
                FittedBox(
                    child: TextButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.grey[400],
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Color.fromARGB(255, 102, 102, 102),
                      highlightColor: Color.fromARGB(255, 187, 187, 187),
                      child: Text(
                        AppLocalizations.of(context)!.signUp,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  onPressed: context.watch<SignInProvider>().inProgress
                      ? null
                      : _signUp,
                )),
              ]),
            ])),
      ),
    );
  }

  _signUp() async {
    try {
      if (await context.read<SignInProvider>().signUp(
            _emailFieldController.text.trim(),
            _passwordFieldController.text.trim(),
          )) {
        // success
        if (_isSaveSignInInfo) {
          // save signin info
          context.read<SignInProvider>().saveSigninCredentials(
              SigninCredentials(
                  username: _emailFieldController.text.trim(),
                  password: _passwordFieldController.text.trim()));
        }
        await context.read<SignInProvider>().registerUser();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VerifyCodeView()),
            (route) => false);
      } else {
        // failed
        CommonWidget.showYesDialog(
            context,
            AppLocalizations.of(context)!.signIn,
            AppLocalizations.of(context)!.signInNotAuthorize);
      }
    } on UsernameExistsException catch (e) {
      print(e);
      CommonWidget.showYesDialog(context, AppLocalizations.of(context)!.signIn,
          AppLocalizations.of(context)!.userAlreadyExistInfoMsg);
      context.read<SignInProvider>().inProgress = false;
    }
  }

  _emailValidate(String _email) {
    print('email: $_email');
    if (false == EmailValidator.validate(_email)) {
      setState(() {
        _emailIcon = const Icon(
          Icons.email,
          color: Colors.red,
        );
        _emailErrMsg = AppLocalizations.of(context)!.invalidEmail;
      });
    } else {
      setState(() {
        _emailIcon = const Icon(
          Icons.email,
          color: Colors.green,
        );
        _emailErrMsg = null;
      });
    }
  }

  _passwordValidate(String _password) {
    print('password: $_password');
    if (_password.length < _passwordMinLength) {
      setState(() {
        _passwordIcon = const Icon(
          Icons.password,
          color: Colors.red,
        );
        _passwordErrMsg = AppLocalizations.of(context)!.passwordShould8Length;
      });
    } else {
      setState(() {
        _passwordIcon = const Icon(
          Icons.password,
          color: Colors.green,
        );
        _passwordErrMsg = null;
      });
    }
  }
}
