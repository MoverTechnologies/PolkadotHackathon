import 'package:flutter/material.dart';

class MenuModel {
  final Icon icon;
  final Icon activeIcon;
  final String label;
  final String tooltip;
  final Widget child;

  const MenuModel({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tooltip,
    required this.child,
  });
}
