import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mover/app/pages/mod_order/views/mod_offer_chack.dart';

import '../providers/mod_search_provider.dart';

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
            delegate: SliverChildListDelegate(widget.mod.employmentRequests
                .asMap()
                .entries
                .map(
                  (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: ListTile(
                        tileColor: Theme.of(context).cardColor,
                        title: Column(children: [
                          Text(e.value.periodOfMonth.toString()),
                        ]),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ModOfferCheckView(
                                  mod: widget.mod,
                                  employmentRequest: e.value)));
                        },
                        subtitle: Text(
                          e.value.hourOfDay.toString(),
                          textAlign: TextAlign.center,
                        ),
                        leading: Text(
                          "${e.value.periodOfMonth}\nmon",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onLongPress: () => {},
                        trailing: Text(
                          "\$${e.value.price}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )),
                )
                .toList()),
          ),
        ],
      ),
    );

    Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).primaryIconTheme.color),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                child: FittedBox(
                                  child: RatingBar.builder(
                                    initialRating: widget.mod.rating.total,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
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
                              Text(
                                  "${widget.mod.user.name}(${widget.mod.rating.expDao})",
                                  style: Theme.of(context).textTheme.headline6),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: _userExperienceChips()),
                            ],
                          ))
                    ],
                  )),
              ListView(shrinkWrap: true, children: <Widget>[
                SingleChildScrollView(
                  child: DataTable(
                    sortColumnIndex: _currentSortColumn,
                    sortAscending: _isAscending,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.amber[200]),
                    columns: [
                      DataColumn(
                          label: Text('Id'),
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _products.sort((productA, productB) =>
                                    productB['price']
                                        .compareTo(productA['price']));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _products.sort((productA, productB) =>
                                    productA['price']
                                        .compareTo(productB['price']));
                              }
                            });
                          }),
                      const DataColumn(label: Text('Name')),
                      DataColumn(
                          label: const Text(
                            'Price',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          // Sorting function
                          onSort: (columnIndex, _) {
                            setState(() {
                              _currentSortColumn = columnIndex;
                              if (_isAscending == true) {
                                _isAscending = false;
                                // sort the product list in Ascending, order by Price
                                _products.sort((productA, productB) =>
                                    productB['price']
                                        .compareTo(productA['price']));
                              } else {
                                _isAscending = true;
                                // sort the product list in Descending, order by Price
                                _products.sort((productA, productB) =>
                                    productA['price']
                                        .compareTo(productB['price']));
                              }
                            });
                          }),
                    ],
                    rows: _products.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item['id'].toString())),
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['price'].toString()))
                      ]);
                    }).toList(),
                  ),
                ),
              ]),
            ],
          ),
        ));
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
