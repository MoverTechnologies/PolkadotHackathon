import 'dart:convert';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/providers/user_provider.dart';
import 'package:mover/app/common/providers/wallet_provider.dart';
import 'package:mover/app/pages/mod_order/models/mod_model.dart';
import 'package:mover/app/pages/task_status/models/task_status_model.dart';
import 'package:mover/models/EmploymentRequest.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'mod_pay_complete_view.dart';

class ModPayCheckView extends StatefulWidget {
  const ModPayCheckView({Key? key, required this.mod, required this.request})
      : super(key: key);

  final ModModel mod;
  final EmploymentRequest request;

  @override
  State<ModPayCheckView> createState() => _ModPayCheckViewState();
}

class _ModPayCheckViewState extends State<ModPayCheckView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).primaryIconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            flexibleSpace: SizedBox(
                height: 200,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 50,
                          backgroundImage: NetworkImage(
                            widget.mod.user.iconUrl,
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                Row(children: [
                                  Container(
                                    width: 80,
                                    child: FittedBox(
                                      child: RatingBar.builder(
                                        initialRating: widget.mod.rating.total,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.black,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: widget.mod.user.languagesAsISO639!
                                        .asMap()
                                        .entries
                                        .map(
                                          (e) => SizedBox(
                                              width: 32,
                                              height: 32,
                                              child: FittedBox(
                                                  child: Chip(
                                                label: Text(
                                                  e.value,
                                                ),
                                              ))),
                                        )
                                        .toList(),
                                  )
                                ]),
                                Text(
                                    "${widget.mod.user.nickname}(${widget.mod.rating.expDao})",
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: _userExperienceChips()),
                              ],
                            ))
                      ],
                    ))),
            expandedHeight: 200,
            collapsedHeight: 200,
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.groups,
                                size: 32,
                                color: Colors.grey,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    widget.mod.user.company ?? "No company",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ))
                            ],
                          )),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 32,
                            color: Colors.grey,
                          ),
                          FittedBox(
                              child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.request.periodMonth}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text("mon")
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.request.hourPerDay}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text("h/week")
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.request.dayPerMonth}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                      Text("d/mon")
                                    ],
                                  )),
                            ],
                          )
                              // Text(
                              //   "${widget.request.periodMonth}mon ${widget.request.hourPerMonth}h/week ${widget.request.dayPerMonth}d/mon",
                              //   style:
                              //       Theme.of(context).textTheme.headline5,
                              // )
                              )
                        ],
                      ),
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("start",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  Text(
                                    _formatter.format(widget.request.start!
                                        .getDateTimeInUtc()),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("end",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  Text(
                                    _formatter.format(
                                        widget.request.end!.getDateTimeInUtc()),
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              )
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.monetization_on,
                                size: 32,
                                color: Colors.grey,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("currency",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      Text(
                                        widget.request.currency
                                            .toString()
                                            .split('.')
                                            .last,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    "\$${widget.request.price}",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  )),
                            ],
                          )),
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock,
                                size: 32,
                                color: Colors.grey,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Lock",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      Text(
                                        widget.request.lockMonth.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 64,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Vesting",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      Text(
                                        widget.request.vestingMonth.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      ),
                                    ],
                                  )),
                            ],
                          )),
                      // Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //     child: Row(
                      //       children: [
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text("start",
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .bodySmall),
                      //             Text(
                      //               widget.request.price.toString(),
                      //               style:
                      //                   Theme.of(context).textTheme.headline5,
                      //             )
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           width: 16,
                      //         ),
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text("end",
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .bodySmall),
                      //             Text(
                      //               widget.request.price.toString(),
                      //               style:
                      //                   Theme.of(context).textTheme.headline5,
                      //             )
                      //           ],
                      //         )
                      //       ],
                      //     )),
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 32.0),
                          child: TextButton(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 30),
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
                                    baseColor:
                                        Color.fromARGB(255, 102, 102, 102),
                                    highlightColor:
                                        Color.fromARGB(255, 187, 187, 187),
                                    child: (context
                                            .watch<WalletProvider>()
                                            .inProgress)
                                        ? SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                        .contract +
                                                    AppLocalizations.of(
                                                            context)!
                                                        .complete,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                              const Icon(Icons.arrow_forward)
                                            ],
                                          )),
                              ),
                              onPressed: () async {
                                try {
                                  // TODO: call update contract api. start Lock and vesting
                                  await context
                                      .read<WalletProvider>()
                                      .completeAgreement(
                                          widget.request.agreementId!, "good");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ModPayCompleteView(
                                                mod: widget.mod,
                                                request: widget.request,
                                              )),
                                      (route) => false);
                                } catch (e) {
                                  print(e);
                                }
                              })),
                    ],
                  ))
            ]),
          ),
        ],
      ),
    );
  }

  Widget _userExperienceChips() {
    return Wrap(
      children: [
        Chip(
          label: Text(
            "${widget.mod.rating.toExpDaoString()}",
          ),
        ),
        if (widget.mod.rating.isEns)
          Chip(
              label: Text(
            "ENS",
          )),
      ],
    );
  }

  final _formatter = DateFormat('yyyy/MM/dd');
}
