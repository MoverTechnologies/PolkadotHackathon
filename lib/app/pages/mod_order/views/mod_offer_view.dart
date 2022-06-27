import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:mover/app/pages/mod_order/models/mod_model.dart';
import 'package:mover/app/pages/mod_order/views/mod_offer_check.dart';

class ModOfferView extends StatefulWidget {
  ModOfferView({Key? key, required this.mod}) : super(key: key);

  final ModModel mod;

  @override
  State<ModOfferView> createState() => _ModOfferViewState();
}

class _ModOfferViewState extends State<ModOfferView> {
  int _currentSortColumn = 0;
  bool _isAscending = true;

  final List<Map> _products = List.generate(30, (i) {
    return {"id": i, "name": "Product $i", "price": Random().nextInt(200) + 1};
  });
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
            delegate: SliverChildListDelegate(widget.mod.employmentRequests
                .where((element) => (null == element.employerWallet))
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ModOfferCheckView(
                                mod: widget.mod, employmentRequest: e.value)));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8.0),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Stack(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          size: 80,
                                          color: Theme.of(context)
                                              .cardColor
                                              .withAlpha(150),
                                        ),
                                        Positioned(
                                          top: 12,
                                          left: 0,
                                          child: Container(
                                              width: 80,
                                              height: 80,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${e.value.periodMonth}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline4,
                                                  ),
                                                  Text("mon",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                ],
                                              )),
                                        )
                                      ],
                                    ),
                                    Container(
                                        width: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.value.hourPerDay}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            Text("h/day",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                          ],
                                        )),
                                    Container(
                                        width: 80,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${e.value.dayPerMonth}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                            Text("d/mon",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),
                                          ],
                                        )),
                                    Container(
                                      width: 80,
                                      child: FittedBox(
                                          child: Text(
                                        "\$${NumberFormat("#,###").format(e.value.price)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      )),
                                    ),
                                  ])))),
                )
                .toList()),
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
        // if (widget.mod.rating.isEns)
        //   Chip(
        //       label: Text(
        //     "ENS",
        //   )),
      ],
    );
  }
}
