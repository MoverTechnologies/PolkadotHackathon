import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mover/app/pages/mod_order/models/mod_model.dart';
import 'package:mover/app/pages/mod_order/views/mod_task_status_view.dart';
import 'package:mover/models/EmploymentRequest.dart';
import 'package:shimmer/shimmer.dart';

class ModOfferCompleteView extends StatelessWidget {
  const ModOfferCompleteView(
      {Key? key, required ModModel this.mod, required this.request})
      : super(key: key);
  final ModModel mod;
  final EmploymentRequest request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(AppLocalizations.of(context)!.contract +
                  " " +
                  AppLocalizations.of(context)!.complete +
                  "!")),
          Center(
            child: Lottie.asset('assets/lottie/lottie-success.json'),
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
                          AppLocalizations.of(context)!.complete,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Icon(Icons.arrow_forward)
                      ],
                    )),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ModTaskStatusView(
                              mod: mod,
                              request: request,
                            )),
                    (route) => false);
              }),
        ],
      )),
    );
  }
}
