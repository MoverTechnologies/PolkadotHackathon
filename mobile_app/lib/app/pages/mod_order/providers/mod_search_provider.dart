import 'package:flutter/material.dart';
import 'package:mover/app/common/utils/remote_config.dart';

import '../models/mod_model.dart';
import '../repositories/mod_search_repository.dart';

class ModSearchProvider with ChangeNotifier {
  List<ModModel> _modModels = [];
  List<ModModel> _showModModels = [];
  List<ModModel> get resultMods => _showModModels;

  final ModSearchRepository _repository = ModSearchRepository();

  final ModSearchConfig modSearchRequest =
      RemoteConfigService.getModSearchRequestConfig();

  ModSearchRequest _selectedItems = ModSearchRequest(items: {});
  ModSearchRequest get selectedItems => _selectedItems;

  List<String> _selectedKeywords = [];
  List<String> get selectedKeywords => _selectedKeywords;

  bool _isUpdading = false;
  bool get isUpdading => _isUpdading;

  bool _isSelected = false;
  bool get isSelected => _isSelected;

  set isSelected(__isSelected) {
    _isSelected = __isSelected;

    notifyListeners();
  }

  int _selectStatsIdx = 0;
  int get selectStatsIdx => _selectStatsIdx;

  set selectStatsIdx(__selectStatsIdx) {
    _selectStatsIdx = _selectStatsIdx;
    isSelected = true;
    notifyListeners();
  }

  init() async {}

  sortByHot() {
    print("sortByHot");
    _modModels.sort((a, b) => b.rating.total.compareTo(a.rating.total));
    notifyListeners();
  }

  sortByName() {
    print("sortByName");
    _modModels.sort((a, b) {
      return a.user.nickname
          .toLowerCase()
          .compareTo(b.user.nickname.toLowerCase());
    });
    notifyListeners();
  }

  runFilter(String _input) {
    _showModModels = _modModels
        .where(
            (e) => e.user.nickname.toLowerCase().contains(_input.toLowerCase()))
        .toList();

    notifyListeners();
  }

  search() async {
    _isUpdading = true;
    notifyListeners();

    _modModels = await _repository.searchMods(getRequest());

    _showModModels = _modModels;

    _isUpdading = false;
    notifyListeners();
  }

  ModSearchRequest getRequest() {
    ModSearchRequest _modSearchRequest = _selectedItems;
    _modSearchRequest.items.addAll({
      "keyword": ModSearchRequestItem(
        header: ModSearchConfigHeader(
          key: "keyword",
          name: "keyword",
          omitName: "words",
          type: "selectable",
        ),
        item: _selectedKeywords,
      )
    });
    return _modSearchRequest;
  }

  onAddItem(ModSearchRequestItem _item) {
    print("${_item.header.key} : $_item");
    if ("keyword" == _item.header.key) {
      _onAddKeyword(_item.item["key"]);
    } else {
      _selectedItems.items[_item.header.key] = _item;
      print("-> ${_selectedItems.items[_item.header.key]}");
      notifyListeners();
    }
  }

  onDeleteItem(ModSearchRequestItem _item) {
    print(_item.header.key);
    if ("keyword" == _item.header.key) {
      _onDeleteKeyword(_item.item["key"]);
    } else {
      _selectedItems.items.remove(_item.header.key);
      notifyListeners();
    }
  }

  _onAddKeyword(String _keyword) {
    print("$_keyword");
    if (false == _selectedKeywords.contains(_keyword)) {
      _selectedKeywords.add(_keyword);
      notifyListeners();
    }
  }

  _onDeleteKeyword(String _keyword) {
    print("$_keyword");
    if (_selectedKeywords.contains(_keyword)) {
      _selectedKeywords.remove(_keyword);
      notifyListeners();
    }
  }
}
