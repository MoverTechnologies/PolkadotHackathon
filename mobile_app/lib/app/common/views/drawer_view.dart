import 'package:flutter/material.dart';
import 'package:mover/app/common/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(180, 250, 250, 250),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(31, 38, 135, 0.4),
              blurRadius: 8.0,
            )
          ],
          border: Border(
            right: BorderSide(
              color: Colors.white70,
            ),
          ),
        ),
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      size: 50,
                      color: Colors.grey,
                    )),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: context
                      .select((MenuProvider _model) => _model.menuList)
                      .asMap()
                      .entries
                      .map((e) => Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          padding: EdgeInsets.only(bottom: 4),
                          child: ListTile(
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      e.value.label,
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    )
                                  ]),
                              onTap: () {
                                context.read<MenuProvider>().currentSelect =
                                    e.key;
                                Navigator.pop(context);
                              },
                              selectedTileColor:
                                  const Color.fromARGB(255, 42, 65, 66))))
                      .toList(),
                )),
              ]),
        ));
  }
}
