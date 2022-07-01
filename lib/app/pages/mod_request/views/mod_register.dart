import 'dart:math';

import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/providers/user_provider.dart';
import 'package:mover/app/pages/mod_order/models/mod_model.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';
import 'package:mover/models/EmploymentRequest.dart';
import 'package:mover/models/MoverUser.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'mod_register_complete_view.dart';

class ModRegisterView extends StatefulWidget {
  const ModRegisterView({Key? key}) : super(key: key);

  @override
  State<ModRegisterView> createState() => _ModRegisterViewState();
}

class _ModRegisterViewState extends State<ModRegisterView> {
  DateTime _start = DateTime.now();
  final DateTime _now = DateTime.now();
  Currency _currency = Currency.values.first;
  int _lockMonth = 2;
  int _vestingMonth = 3;

  TextEditingController _priceTextController = TextEditingController();
  int get _price => int.parse(_priceTextController.text.trim());
  int _dayPerMonth = 20;
  int _periodMonth = 1;
  double _hourPerDay = 5;

  String? _priceErrMsg;

  @override
  void initState() {
    _priceTextController.text = "100";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MoverUser? _user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryIconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: (null == _user)
          ? Center(
              child: Text(""),
            )
          : CustomScrollView(
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
                                  _user.iconUrl,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        Row(
                                          children: _user.languagesAsISO639!
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
                                      Text("${_user.nickname}", style: Theme.of(context).textTheme.headline6),
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
                                          _user.company ?? "No company",
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
                                            DropdownButton<int>(
                                              items: <int>[1, 2, 3].map((int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    value.toString(),
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                );
                                              }).toList(),
                                              value: _periodMonth,
                                              onChanged: (value) => setState(() => _periodMonth = value ?? 2),
                                            ),
                                            Text("mon")
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            DropdownButton<int>(
                                              items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    value.toString(),
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                );
                                              }).toList(),
                                              value: _hourPerDay.toInt(),
                                              onChanged: (value) => setState(() => _hourPerDay = value!.toDouble()),
                                            ),
                                            Text("h/day")
                                          ],
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            DropdownButton<int>(
                                              items: <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24].map((int value) {
                                                return DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    value.toString(),
                                                    style: Theme.of(context).textTheme.headline5,
                                                  ),
                                                );
                                              }).toList(),
                                              value: _dayPerMonth,
                                              onChanged: (value) => setState(() => _dayPerMonth = value ?? 20),
                                            ),
                                            Text("d/mon")
                                          ],
                                        )),
                                  ],
                                ))
                              ],
                            ),
                            SizedBox(height: 8),
                            // Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 10.0),
                            //     child: Row(
                            //       children: [
                            //         IconButton(
                            //             onPressed: () async {
                            //               final DateTime? picked =
                            //                   await showDatePicker(
                            //                       context: context,
                            //                       initialDate: _start,
                            //                       firstDate: _start,
                            //                       lastDate: _now
                            //                           .add(Duration(days: 60)));
                            //               if (picked != null) {
                            //                 setState(() => _start = DateTime(
                            //                     picked.year,
                            //                     picked.month,
                            //                     picked.day));
                            //               }
                            //             },
                            //             alignment: Alignment.topRight,
                            //             icon: Icon(
                            //               Icons.timer_sharp,
                            //               size: 20,
                            //               color: Colors.amber,
                            //             )),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Row(
                            //               children: [
                            //                 Text("start",
                            //                     style: Theme.of(context)
                            //                         .textTheme
                            //                         .bodySmall),
                            //               ],
                            //             ),
                            //             Text(
                            //               _formatter.format(_start),
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline5,
                            //             )
                            //           ],
                            //         ),
                            //         SizedBox(
                            //           width: 16,
                            //         ),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text("end",
                            //                 style: Theme.of(context)
                            //                     .textTheme
                            //                     .bodySmall),
                            //             Text(
                            //               _formatter.format(DateTime(
                            //                   _start.year,
                            //                   _start.month + _periodMonth,
                            //                   _start.day)),
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline5!
                            //                   .copyWith(color: Colors.grey),
                            //             )
                            //           ],
                            //         )
                            //       ],
                            //     )),
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
                                    Container(
                                        width: 100,
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: TextField(
                                          controller: _priceTextController,
                                          onTap: () {
                                            _priceTextController.clear();
                                            _priceErrMsg = null;
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "\$price",
                                            errorText: _priceErrMsg,
                                          ),
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        )),
                                  ],
                                )),
                            SizedBox(height: 8),
                            // Padding(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 1.0),
                            //     child: Row(
                            //       children: [
                            //         Icon(
                            //           Icons.lock,
                            //           size: 32,
                            //           color: Colors.grey,
                            //         ),
                            //         Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 8.0),
                            //             child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text("Lock",
                            //                     style: Theme.of(context)
                            //                         .textTheme
                            //                         .bodySmall),
                            //                 DropdownButton<int>(
                            //                   items: <int>[0, 1, 2, 3]
                            //                       .map((int value) {
                            //                     return DropdownMenuItem<int>(
                            //                       value: value,
                            //                       child: Text(
                            //                         value.toString(),
                            //                         style: Theme.of(context)
                            //                             .textTheme
                            //                             .headline5,
                            //                       ),
                            //                     );
                            //                   }).toList(),
                            //                   value: _lockMonth,
                            //                   onChanged: (value) => setState(
                            //                       () =>
                            //                           _lockMonth = value ?? 2),
                            //                 ),
                            //               ],
                            //             )),
                            //         SizedBox(
                            //           width: 64,
                            //         ),
                            //         Padding(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 8.0),
                            //             child: Column(
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text("Vesting",
                            //                     style: Theme.of(context)
                            //                         .textTheme
                            //                         .bodySmall),
                            //                 DropdownButton<int>(
                            //                   items: <int>[0, 1, 2, 3]
                            //                       .map((int value) {
                            //                     return DropdownMenuItem<int>(
                            //                       value: value,
                            //                       child: Text(
                            //                         value.toString(),
                            //                         style: Theme.of(context)
                            //                             .textTheme
                            //                             .headline5,
                            //                       ),
                            //                     );
                            //                   }).toList(),
                            //                   value: _vestingMonth,
                            //                   onChanged: (value) => setState(
                            //                       () => _vestingMonth =
                            //                           value ?? 3),
                            //                 ),
                            //               ],
                            //             )),
                            //       ],
                            //     )),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!.register,
                                                style: Theme.of(context).textTheme.titleLarge,
                                              ),
                                              const Icon(Icons.arrow_forward)
                                            ],
                                          )),
                                    ),
                                    onPressed: () async {
                                      if (_priceTextController.text.isEmpty) {
                                        _priceErrMsg = AppLocalizations.of(context)!.price;
                                        return;
                                      }
                                      final _user = context.read<UserProvider>().user;
                                      if (null != _user) {
                                        EmploymentRequest _new = EmploymentRequest(
                                          employerWallet: context.read<UserProvider>().user!.wallet,
                                          start: TemporalDateTime(_start),
                                          end: TemporalDateTime(DateTime(_start.year, _start.month + _periodMonth, _start.day)),
                                          price: _price,
                                          currency: _currency.toString().split('.').last,
                                          lockMonth: _lockMonth,
                                          vestingMonth: _vestingMonth,
                                          dayPerMonth: _dayPerMonth,
                                          periodMonth: _periodMonth,
                                          hourPerDay: _hourPerDay,
                                        );
                                        await AmplifyEndpoint().registerEmploymentRequest(
                                          _user.wallet,
                                          _periodMonth,
                                          _dayPerMonth,
                                          _hourPerDay,
                                          _currency,
                                          _price,
                                        );
                                        print(_new);
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ModRegisterCompleteView()), (route) => false);
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
          backgroundColor: Colors.purpleAccent,
          label: FittedBox(
              child: Text(
            "Polygon Hacker House 2022",
          )),
        ),
      ],
    );
  }

  final _formatter = DateFormat('yyyy/MM/dd');
}
