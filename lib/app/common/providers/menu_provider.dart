import 'package:flutter/material.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';

import '../models/menu_model.dart';

class MenuProvider with ChangeNotifier {
  final List<MenuModel> _menuList = const [
    MenuModel(
      icon: Icon(Icons.bar_chart_rounded),
      activeIcon: Icon(Icons.graphic_eq_outlined),
      label: 'TopPage',
      tooltip: 'TopPage',
      child: TopView(),
    ),
  ];

  List<MenuModel> get menuList => _menuList;

  int _currentSelect = 0;

  MenuModel get currentSelectMenu => _menuList[_currentSelect];

  set currentSelect(_select) {
    _currentSelect = _select;

    notifyListeners();
  }
}
