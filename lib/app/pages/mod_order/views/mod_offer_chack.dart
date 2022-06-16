import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/mod_search_provider.dart';
import 'mod_offer_complete_view.dart';

class ModOfferCheckView extends StatefulWidget {
  ModOfferCheckView(
      {Key? key, required this.mod, required this.employmentRequest})
      : super(key: key);

  final ModModel mod;
  final EmploymentRequestModel employmentRequest;

  @override
  State<ModOfferCheckView> createState() => _ModOfferCheckViewState();
}

class _ModOfferCheckViewState extends State<ModOfferCheckView> {
  int _currentSortColumn = 0;
  bool _isAscending = true;

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
                            widget.mod.user.avatar,
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
                                    children: widget.mod.user.languarges
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
                                    "${widget.mod.user.name}(${widget.mod.rating.expDao})",
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
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.abc_outlined),
                      Text(
                        widget.mod.user.company,
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.abc_outlined),
                      Text(
                        "${widget.employmentRequest.periodOfMonth}mon ${widget.employmentRequest.hourOfDay}h/week ${widget.employmentRequest.dayOfMonth}d/mon",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("start",
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                widget.employmentRequest.price.toString(),
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
                              Text("end",
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                widget.employmentRequest.price.toString(),
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          )
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.monetization_on),
                      Text(
                        "${widget.employmentRequest.price}",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        "\$${widget.employmentRequest.price}",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.lock),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lock",
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            widget.employmentRequest.price.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vesting",
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            widget.employmentRequest.price.toString(),
                            style: Theme.of(context).textTheme.headline5,
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("start",
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                widget.employmentRequest.price.toString(),
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
                              Text("end",
                                  style: Theme.of(context).textTheme.bodySmall),
                              Text(
                                widget.employmentRequest.price.toString(),
                                style: Theme.of(context).textTheme.headline5,
                              )
                            ],
                          )
                        ],
                      )),
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
                                  AppLocalizations.of(context)!.contract,
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
                                builder: (context) => ModOfferCompleteView(
                                      mod: widget.mod,
                                    )),
                            (route) => false);
                      }),
                ],
              )
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
}
