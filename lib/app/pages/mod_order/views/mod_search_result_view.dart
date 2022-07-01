import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mover/app/common/utils/remote_config.dart';
import 'package:mover/app/pages/mod_order/providers/mod_search_provider.dart';
import 'package:mover/app/pages/mod_order/views/mod_offer_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class ModSearchResultView extends StatefulWidget {
  const ModSearchResultView({Key? key}) : super(key: key);

  @override
  State<ModSearchResultView> createState() => _ModSearchResultViewState();
}

class _ModSearchResultViewState extends State<ModSearchResultView> {
  List<DropdownMenuItem<int>>? _items; //TODO: sort model
  int _selectItem = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    // set dropdown menu items

    List<Widget> _selectedWidget = [];

    _selectedWidget.addAll(context.watch<ModSearchProvider>().selectedKeywords.asMap().entries.map((e) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Chip(
          label: Text(e.value),
        ),
      );
    }).toList());
    _selectedWidget.addAll(context.watch<ModSearchProvider>().selectedItems.items.entries.map((e) {
      if ("keyword" == e.key) {
        return Container();
      }
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Chip(
            label: Text("${e.value.header.omitName} ${e.value.item["key"]}"),
          ));
    }).toList());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryIconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: (context.watch<ModSearchProvider>().isUpdading)
            ? Lottie.asset('assets/lottie/lottie-searching.json')
            : Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(
                    "${context.watch<ModSearchProvider>().resultMods.length}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    "mods",
                    style: Theme.of(context).textTheme.headline6,
                  )
                ]),
                SizedBox(height: 16),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: (_selectedWidget.isEmpty)
                        ? SizedBox(
                            height: 50,
                          )
                        : Wrap(children: _selectedWidget)),
                Align(alignment: Alignment.centerRight, child: DropdownButton(icon: const Icon(Icons.sort), items: _items, value: _selectItem, onChanged: _sort)),
                Center(
                  child: Column(
                      children: context
                          .watch<ModSearchProvider>()
                          .resultMods
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                                child: ListTile(
                                  tileColor: Theme.of(context).cardColor,
                                  title: Column(children: [
                                    Container(
                                      width: 100,
                                      child: FittedBox(
                                        child: RatingBar.builder(
                                          initialRating: e.value.rating.total,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ),
                                    ),
                                    Text(e.value.user.nickname)
                                  ]),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModOfferView(mod: e.value)));
                                  },
                                  subtitle: Text(
                                    e.value.rating.toExpDaoString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  leading: Text(
                                    "${e.value.employmentRequests.first.periodMonth}\nmon",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  onLongPress: () => {},
                                  trailing: Text(
                                    "\$${NumberFormat("#,###").format(e.value.employmentRequests.last.price)}",
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                )),
                          )
                          .toList()),
                ),
              ]),
      ),
    );
  }

  _runFilter(String _input) {
    context.read<ModSearchProvider>().runFilter(_input);
  }

  _sort(int? value) {
    print("sort ${_items![_selectItem].value} to $value");
    setState(() {
      _selectItem = value ?? 1;
    });
  }

  setItems() {
    _items = [];
    _items!
      ..add(DropdownMenuItem(
        child: Text(
          "",
          style: Theme.of(context).textTheme.headline6,
        ),
        value: 0,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          AppLocalizations.of(context)!.experienceOfDao,
          style: Theme.of(context).textTheme.headline6,
        ),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          AppLocalizations.of(context)!.nftHeld,
          style: Theme.of(context).textTheme.headline6,
        ),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          AppLocalizations.of(context)!.price,
          style: Theme.of(context).textTheme.headline6,
        ),
        value: 3,
      ));
    _selectItem = _items!.first.value!;
  }
}
