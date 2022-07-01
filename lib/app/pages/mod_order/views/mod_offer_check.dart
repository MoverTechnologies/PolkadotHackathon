import 'dart:convert';
import 'dart:math';

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
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/mod_search_provider.dart';
import 'mod_offer_complete_view.dart';

class ModOfferCheckView extends StatefulWidget {
  ModOfferCheckView({Key? key, required this.mod, required this.employmentRequest}) : super(key: key);

  final ModModel mod;
  final EmploymentRequest employmentRequest;

  @override
  State<ModOfferCheckView> createState() => _ModOfferCheckViewState();
}

class _ModOfferCheckViewState extends State<ModOfferCheckView> {
  int _currentSortColumn = 0;
  bool _isAscending = true;
  DateTime _start = new DateTime.now().add(Duration(seconds: 60));
  final DateTime _tomorrow = DateTime.now().add(Duration(seconds: 60));
  Currency _currency = Currency.values.first;
  int _lockMonth = 2;
  int _vestingMonth = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryIconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
                                Text("${widget.mod.user.nickname}(${widget.mod.rating.expDao})", style: Theme.of(context).textTheme.headline6),
                                Container(width: MediaQuery.of(context).size.width * 0.5, child: _userExperienceChips()),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    widget.mod.user.company ?? "No company",
                                    style: Theme.of(context).textTheme.headline5,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.employmentRequest.periodMonth}",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text("mon")
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.employmentRequest.hourPerDay}",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text("h/day")
                                    ],
                                  )),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${widget.employmentRequest.dayPerMonth}",
                                        style: Theme.of(context).textTheme.headline5,
                                      ),
                                      Text("d/mon")
                                    ],
                                  )),
                            ],
                          )
                              // Text(
                              //   "${widget.employmentRequest.periodMonth}mon ${widget.employmentRequest.hourPerMonth}h/week ${widget.employmentRequest.dayPerMonth}d/mon",
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
                              IconButton(
                                  onPressed: () async {
                                    final DateTime? picked = await showDatePicker(context: context, initialDate: _start, firstDate: _start, lastDate: _tomorrow.add(Duration(days: 60)));
                                    if (picked != null) {
                                      setState(() => _start = DateTime(picked.year, picked.month, picked.day));
                                    }
                                  },
                                  alignment: Alignment.topRight,
                                  icon: Icon(
                                    Icons.timer_sharp,
                                    size: 20,
                                    color: Colors.amber,
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("start", style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                  Text(
                                    _formatter.format(_start),
                                    style: Theme.of(context).textTheme.headline5,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("end", style: Theme.of(context).textTheme.bodySmall),
                                  Text(
                                    _formatter.format(DateTime(_start.year, _start.month + widget.employmentRequest.periodMonth, _start.day)),
                                    style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.grey),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("currency", style: Theme.of(context).textTheme.bodySmall),
                                      DropdownButton<Currency>(
                                        items: Currency.values.map((Currency value) {
                                          return DropdownMenuItem<Currency>(
                                            value: value,
                                            child: Text(
                                              value.toString().split('.').last,
                                              style: Theme.of(context).textTheme.headline5,
                                            ),
                                          );
                                        }).toList(),
                                        value: _currency,
                                        onChanged: (value) => setState(() => _currency = value ?? Currency.values.first),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 16,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "\$${widget.employmentRequest.price}",
                                    style: Theme.of(context).textTheme.headline5,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Lock", style: Theme.of(context).textTheme.bodySmall),
                                      DropdownButton<int>(
                                        items: <int>[0, 1, 2, 3].map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: Theme.of(context).textTheme.headline5,
                                            ),
                                          );
                                        }).toList(),
                                        value: _lockMonth,
                                        onChanged: (value) => setState(() => _lockMonth = value ?? 2),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: 64,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Vesting", style: Theme.of(context).textTheme.bodySmall),
                                      DropdownButton<int>(
                                        items: <int>[0, 1, 2, 3].map((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(
                                              value.toString(),
                                              style: Theme.of(context).textTheme.headline5,
                                            ),
                                          );
                                        }).toList(),
                                        value: _vestingMonth,
                                        onChanged: (value) => setState(() => _vestingMonth = value ?? 3),
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
                      //               widget.employmentRequest.price.toString(),
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
                      //               widget.employmentRequest.price.toString(),
                      //               style:
                      //                   Theme.of(context).textTheme.headline5,
                      //             )
                      //           ],
                      //         )
                      //       ],
                      //     )),
                      SizedBox(height: 8),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
                          child: TextButton(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                margin: const EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [Color.fromARGB(255, 206, 219, 26), Color.fromARGB(255, 113, 211, 34)],
                                    begin: FractionalOffset.centerLeft,
                                    end: FractionalOffset.centerRight,
                                  ),
                                ),
                                child: Shimmer.fromColors(
                                    baseColor: Color.fromARGB(255, 102, 102, 102),
                                    highlightColor: Color.fromARGB(255, 187, 187, 187),
                                    child: (context.watch<WalletProvider>().inProgress)
                                        ? SizedBox(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.contract,
                                                style: Theme.of(context).textTheme.titleLarge,
                                              ),
                                              const Icon(Icons.arrow_forward)
                                            ],
                                          )),
                              ),
                              onPressed: () async {
                                final _user = context.read<UserProvider>().user;
                                if (null != _user) {
                                  EmploymentRequest? _new;
                                  String? agreementId;
                                  try {
                                    // ==========================================
                                    // contract call
                                    // ==========================================
                                    agreementId = await context.read<WalletProvider>().createAgreeement(
                                        widget.employmentRequest.employeeWallet!,
                                        "demoDao",
                                        widget.employmentRequest.price,
                                        DateTimeRange(
                                          start: _start,
                                          // end: DateTime(
                                          //     _start.year,
                                          //     _start.month +
                                          //         widget.employmentRequest
                                          //             .periodMonth,
                                          //     _start.day),
                                          end: _start.add(
                                            Duration(seconds: 10),
                                          ),
                                        ));
                                    if (null == agreementId) {
                                      // failed to contract call
                                      return;
                                    }
                                    print("agreementId: $agreementId");

                                    _new = widget.employmentRequest.copyWith(
                                      agreementId: agreementId,
                                      employerWallet: context.read<UserProvider>().user!.wallet,
                                      start: TemporalDateTime(_start),
                                      end: TemporalDateTime(DateTime(_start.year, _start.month + widget.employmentRequest.periodMonth, _start.day)),
                                      currency: _currency.toString().split('.').last,
                                      lockMonth: _lockMonth,
                                      vestingMonth: _vestingMonth,
                                    );
                                    print("agreementId2: ${_new.agreementId}");
                                    _new = _new.copyWith(
                                      progressStatus: jsonEncode(TaskStatusModel.fromEmploymentRequest(_new).toJson()),
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                  if (null == _new) {
                                    return;
                                  }
                                  try {
                                    // ==========================================
                                    // save to AWS
                                    // ==========================================
                                    await AmplifyEndpoint().updateEmploymentRequest(_new);
                                    print(_new);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ModOfferCompleteView(
                                                  mod: widget.mod,
                                                  request: _new!,
                                                )),
                                        (route) => false);
                                  } catch (e) {
                                    print(e);
                                  }
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
