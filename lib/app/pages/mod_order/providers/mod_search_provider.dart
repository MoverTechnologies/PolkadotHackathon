import 'package:flutter/material.dart';
import 'package:mover/app/common/endpoint/amplify_endpoint.dart';
import 'package:mover/app/common/utils/remote_config.dart';

class ModModel {
  final UserModel user;
  final ModRatingModel rating;
  final List<EmploymentRequestModel> employmentRequests;

  ModModel(
      {required this.user,
      required this.rating,
      required this.employmentRequests});
}

class UserModel {
  final String name;
  final String avatar;
  final String twitter;
  final String discord;
  final String github;
  final String website;
  final String description;
  final String email;
  final String location;
  final String company;
  final String hireable;
  final String bio;
  final String publicRepos;
  final List<String> languarges;

  UserModel(
      {required this.name,
      required this.avatar,
      required this.twitter,
      required this.discord,
      required this.github,
      required this.website,
      required this.description,
      required this.email,
      required this.location,
      required this.company,
      required this.hireable,
      required this.bio,
      required this.publicRepos,
      required this.languarges});
}

class ModRatingModel {
  final double total;
  final int expDao;
  final bool isEns;

  toExpDaoString() {
    var _ret = "";
    if (expDao < 10) {
      _ret = "<10";
    } else if ((10 < expDao) && (expDao < 100)) {
      _ret = "+10";
    } else if (100 < expDao) {
      _ret = "+100";
    }
    return "$_ret Communities";
  }

  ModRatingModel(
      {required this.total, required this.expDao, required this.isEns});
}

class EmploymentRequestModel {
  final int periodOfMonth;
  final int hourOfDay;
  final int dayOfMonth;
  final int price;

  EmploymentRequestModel(
      {required this.periodOfMonth,
      required this.hourOfDay,
      required this.dayOfMonth,
      required this.price});
}

final List<ModModel> __statsModels = [
  ModModel(
      user: UserModel(
        name: 'John Titor',
        email: '',
        avatar:
            'https://image.binance.vision/editor-uploads-original/9c15d9647b9643dfbc5e522299d13593.png',
        twitter: 'https://twitter.com/astarstats',
        bio: '',
        company: 'AstarStats',
        discord: 'https://discord.gg/astarstats',
        github: '',
        hireable: '',
        location: '',
        publicRepos: '',
        website: 'https://astar-stats.org/',
        description:
            'The first statistic & visualize tool on Astar Network BlockChain.',
        languarges: ["ja", "en"],
      ),
      rating: ModRatingModel(
        total: 4.5,
        expDao: 128,
        isEns: true,
      ),
      employmentRequests: [
        EmploymentRequestModel(
          periodOfMonth: 3,
          dayOfMonth: 20,
          hourOfDay: 10,
          price: 300,
        ),
        EmploymentRequestModel(
          periodOfMonth: 4,
          dayOfMonth: 10,
          hourOfDay: 4,
          price: 600,
        ),
        EmploymentRequestModel(
          periodOfMonth: 5,
          dayOfMonth: 5,
          hourOfDay: 5,
          price: 1500,
        )
      ]),
];

class ModSearchProvider with ChangeNotifier {
  List<ModModel> _modModels = [];
  List<ModModel> _showModModels = [];
  List<ModModel> get resultMods => _showModModels;

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
      return a.user.name.toLowerCase().compareTo(b.user.name.toLowerCase());
    });
    notifyListeners();
  }

  runFilter(String _input) {
    _showModModels = _modModels
        .where((e) => e.user.name.toLowerCase().contains(_input.toLowerCase()))
        .toList();

    notifyListeners();
  }

  search() async {
    _isUpdading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _modModels = __statsModels;
    _showModModels = __statsModels;

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
