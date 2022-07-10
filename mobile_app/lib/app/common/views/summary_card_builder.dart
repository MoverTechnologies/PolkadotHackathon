import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class SumamryCardBuilder extends StatelessWidget {
  const SumamryCardBuilder(
      {Key? key, this.height = 240, this.width = 300, required this.child})
      : super(key: key);

  final double height;
  final double width;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
                height: height,
                width: width,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: context
                        .select((ThemeProvider _model) => _model.gradientColor),
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.bottomRight,
                  ),
                ),
                child: child)));
  }
}
