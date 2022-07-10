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

class MyPageView extends StatefulWidget {
  const MyPageView({Key? key}) : super(key: key);

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
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
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).primaryIconTheme.color),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        SizedBox(
                                            width: 80,
                                            child: FittedBox(
                                              child: RatingBar.builder(
                                                initialRating:
                                                    _user.rating ?? 0,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.black,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            )),
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
                                      Text("${_user.nickname}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: _userExperienceChips()),
                                    ],
                                  ))
                            ],
                          ))),
                  expandedHeight: 200,
                  collapsedHeight: 200,
                  backgroundColor: Colors.white,
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
