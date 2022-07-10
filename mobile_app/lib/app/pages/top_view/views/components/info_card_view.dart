import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:url_launcher/url_launcher.dart';

//TODO: load at remote config
final List<InfoCardModel> imageList = [
  InfoCardModel(
    title: "title1",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2019/12/20/00/03/road-4707345_960_720.jpg",
    moreUrl: "http://google.com",
  ),
  InfoCardModel(
    title: "title1",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/12/03/18/04/christmas-balls-2995437_960_720.jpg",
    moreUrl: "http://google.com",
  ),
  InfoCardModel(
    title: "title3",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2017/12/13/00/23/christmas-3015776_960_720.jpg",
    moreUrl: "http://google.com",
  ),
  InfoCardModel(
    title: "title4",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2019/12/19/10/55/christmas-market-4705877_960_720.jpg",
    moreUrl: "http://google.com",
  ),
  InfoCardModel(
    title: "title5",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2019/12/22/04/18/x-mas-4711785__340.jpg",
    moreUrl: "http://google.com",
  ),
  InfoCardModel(
    title: "title6",
    description:
        "Excellent community Looking for a Excellent customer manager?",
    imageUrl:
        "https://cdn.pixabay.com/photo/2016/11/22/07/09/spruce-1848543__340.jpg",
    moreUrl: "http://google.com",
  ),
];

class InfoCardView extends StatefulWidget {
  InfoCardView({Key? key}) : super(key: key);

  @override
  State<InfoCardView> createState() => _InfoCardViewState();
}

class _InfoCardViewState extends State<InfoCardView> {
  @override
  Widget build(BuildContext context) {
    return GFCarousel(
      hasPagination: true,
      passiveIndicator: Theme.of(context).colorScheme.shadow,
      activeIndicator: Theme.of(context).colorScheme.background,
      viewportFraction: 1.0,
      items: imageList.map(
        (info) {
          return Container(
              width: MediaQuery.of(context).size.width * .90,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(info.imageUrl),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(
                                  info.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: Colors.white),
                                )),
                            TextButton(
                              child: Text(
                                "Learn more >",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white),
                              ),
                              onPressed: () {
                                launchUrl(Uri.parse(info.moreUrl));
                              },
                            )
                          ])),
                ),
              ));
        },
      ).toList(),
      onPageChanged: (index) {
        setState(() {
          index;
        });
      },
    );
  }
}

class InfoCardModel {
  final String title;
  final String description;
  final String imageUrl;
  final String moreUrl;

  InfoCardModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.moreUrl});
}
