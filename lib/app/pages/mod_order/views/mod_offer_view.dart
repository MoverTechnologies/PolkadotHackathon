import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/mod_search_provider.dart';

class ModOfferView extends StatelessWidget {
  const ModOfferView({Key? key, required this.mod}) : super(key: key);

  final ModModel mod;

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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Material(
                      borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(mod.user.avatar,
                            width: 100, height: 100),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        child: FittedBox(
                          child: RatingBar.builder(
                            initialRating: mod.rating.total,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
                      Text(mod.user.name,
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
