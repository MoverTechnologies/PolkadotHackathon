import 'package:flutter/material.dart';
import 'package:mover/app/common/utils/remote_config.dart';
import 'package:mover/app/pages/mod_order/views/mod_search_result_view.dart';
import 'package:provider/provider.dart';

import '../providers/mod_search_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModSearchView extends StatefulWidget {
  ModSearchView({Key? key}) : super(key: key);

  @override
  State<ModSearchView> createState() => _ModSearchViewState();
}

class _ModSearchViewState extends State<ModSearchView> {
  TextEditingController _textFieldController = TextEditingController();

  final ScrollController _chipScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _selectedWidget = [];

    _selectedWidget.addAll(context
        .watch<ModSearchProvider>()
        .selectedKeywords
        .asMap()
        .entries
        .map((e) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Chip(
              label: Text(e.value),
              onDeleted: () {
                context
                    .read<ModSearchProvider>()
                    .onDeleteItem(ModSearchRequestItem(
                        header: ModSearchConfigHeader(
                          key: "keyword",
                          name: "keyword",
                          omitName: "",
                          type: "",
                        ),
                        item: {"key": e.value, "val": e.value}));
              }));
    }).toList());
    _selectedWidget.addAll(
        context.watch<ModSearchProvider>().selectedItems.items.entries.map((e) {
      if ("keyword" == e.key) {
        return Container();
      }
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Chip(
              label: Text("${e.value.header.omitName} ${e.value.item["key"]}"),
              onDeleted: () {
                context.read<ModSearchProvider>().onDeleteItem(e.value);
              }));
    }).toList());

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).primaryIconTheme.color),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search,
                  color: Theme.of(context).primaryIconTheme.color),
              onPressed: () {
                context.read<ModSearchProvider>().search();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ModSearchResultView()));
              },
            ),
            SizedBox(width: 16),
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              flexibleSpace: SizedBox(
                  height: 200,
                  child: Column(children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: _textFieldController,
                          onSubmitted: (_text) {
                            context
                                .read<ModSearchProvider>()
                                .onAddItem(ModSearchRequestItem(
                                    header: ModSearchConfigHeader(
                                      key: "keyword",
                                      name: "keyword",
                                      omitName: "keyword",
                                      type: "",
                                    ),
                                    item: {"key": _text, "val": _text}));
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.search,
                            suffixIcon: IconButton(
                              onPressed: () => _textFieldController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                            controller: _chipScrollController,
                            scrollDirection: Axis.horizontal,
                            child: Row(children: _selectedWidget))),
                  ])),
              expandedHeight: 200,
              collapsedHeight: 150,
              backgroundColor: Colors.white,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Center(child: _selectWidget()),
                SizedBox(
                  height: 30,
                ),
              ]),
            ),
          ],
        ));
  }

  _runFilter(String _input) {
    context.read<ModSearchProvider>().runFilter(_input);
  }

  Widget _selectWidget() {
    final _structure = context.read<ModSearchProvider>().modSearchRequest;

    var _widget = _structure.request.map((e) {
      Widget _elemWidgetList = Container();
      if ("toggleRange" == e.header.type) {
        _elemWidgetList = Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: Row(
                    children: e.items.map((item) {
              final _requestItem =
                  ModSearchRequestItem(header: e.header, item: item);
              return _toggleButton(_requestItem);
            }).toList())));
      } else if ("selectable" == e.header.type) {
        _elemWidgetList = Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: Row(
                    children: e.items.map((item) {
              final _requestItem =
                  ModSearchRequestItem(header: e.header, item: item);
              return _hotwordButton(_requestItem);
            }).toList())));
      } else if ("toggleBool" == e.header.type) {
        _elemWidgetList = Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: Row(
                    children: e.items.map((item) {
              final _requestItem =
                  ModSearchRequestItem(header: e.header, item: item);
              return _toggleButton(_requestItem);
            }).toList())));
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${e.header.name}",
                style: Theme.of(context).textTheme.headline6,
              ),
            )),
        _elemWidgetList,
      ]);
    }).toList();

    return Center(child: Column(children: _widget));
  }

  Widget _toggleButton(ModSearchRequestItem _value) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                  child: Text(
                _value.item["key"],
                style: Theme.of(context).textTheme.titleLarge,
              ))),
          onPressed: () {
            context.read<ModSearchProvider>().onAddItem(_value);
          },
        ));
  }

  Widget _hotwordButton(ModSearchRequestItem _value) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          child: Text(
            _value.item["key"],
            style: Theme.of(context).textTheme.titleMedium,
          ),
          onPressed: () {
            context.read<ModSearchProvider>().onAddItem(_value);
          },
        ));
  }
}
