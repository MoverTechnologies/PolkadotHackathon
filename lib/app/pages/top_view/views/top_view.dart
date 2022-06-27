import 'package:flutter/material.dart';
import 'package:mover/app/common/providers/user_provider.dart';
import 'package:mover/app/pages/mod_order/views/mod_search_view.dart';
import 'package:mover/app/pages/mod_request/views/mod_register.dart';
import 'package:mover/app/pages/top_view/views/components/info_card_view.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class TopView extends StatelessWidget {
  const TopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: FittedBox(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                backgroundImage: (context.watch<UserProvider>().user == null)
                    ? null
                    : NetworkImage(
                        context.watch<UserProvider>().user!.iconUrl,
                      ),
                child: (context.watch<UserProvider>().user == null)
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Column(children: [
          InfoCardView(),
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.request_page,
                                      size: 50,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color,
                                    )),
                                FittedBox(
                                    child: Text(
                                  AppLocalizations.of(context)!.orderMod,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))
                              ])),
                          onPressed:
                              (context.watch<UserProvider>().user == null)
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ModSearchView()));
                                    },
                        )),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          child: Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.home_repair_service,
                                      size: 50,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color,
                                    )),
                                FittedBox(
                                    child: Text(
                                  AppLocalizations.of(context)!.register,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))
                              ])),
                          onPressed:
                              (context.watch<UserProvider>().user == null)
                                  ? null
                                  : () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ModRegisterView()));
                                    },
                        )),
                  ),
                ],
              )),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ModSearchView()));
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search,
                    suffixIcon: Icon(Icons.search)),
              )),
        ]),
      )),
    );
  }
}
