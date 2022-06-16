import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mover/app/common/providers/user_provider.dart';
import 'package:mover/app/pages/mod_order/providers/mod_search_provider.dart';
import 'package:mover/app/pages/task_status/views/task_status_view.dart';
import 'package:mover/app/pages/top_view/views/top_view.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

class ModTaskStatusView extends StatefulWidget {
  ModTaskStatusView({Key? key, required this.mod}) : super(key: key);

  final ModModel mod;

  @override
  State<ModTaskStatusView> createState() => _ModTaskStatusViewState();
}

class _ModTaskStatusViewState extends State<ModTaskStatusView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).primaryIconTheme.color),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TopView()),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 50,
                backgroundImage: NetworkImage(
                  context.watch<UserProvider>().user!.iconUrl!,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          SizedBox(height: 16),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: ListTile(
                tileColor: Theme.of(context).cardColor,
                title: Column(children: [
                  Container(
                    width: 100,
                    child: FittedBox(
                      child: RatingBar.builder(
                        initialRating: widget.mod.rating.total,
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
                  Text(widget.mod.user.name)
                ]),
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ModOfferView(mod: widget.mod)));
                },
                subtitle: Text(
                  widget.mod.rating.toExpDaoString(),
                  textAlign: TextAlign.center,
                ),
                leading: Text(
                  "${widget.mod.employmentRequests.first.periodOfMonth}\nmon",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                onLongPress: () => {},
                trailing: Text(
                  "\$${widget.mod.employmentRequests.first.price}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          TaskStatusView()
        ]),
      ),
    );
  }
}
