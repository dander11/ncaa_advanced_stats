import 'package:flutter/material.dart';
import '../../Models/Models.dart';
import '../InheritedBlocs.dart';
import 'teamOverview.dart';
import 'teamRatings.dart';
import 'teamSchedule.dart';

class TeamDetailPage extends StatelessWidget {
  const TeamDetailPage({
    Key key,
    @required this.team,
    this.schoolName,
  }) : super(key: key);

  final Team team;
  final String schoolName;

  @override
  Widget build(BuildContext context) {
    var mainColor = Color(int.parse("0xff" + team.color.substring(1)));
    var altColor = team.altColor != null
        ? Color(int.parse("0xff" + team.altColor.substring(1)))
        : this.getTextColor(mainColor);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: altColor,
        body: NestedScrollView(
          headerSliverBuilder: (context, a) {
            return [
              SliverAppBar(
                elevation: 0.0,
                backgroundColor: altColor,
                pinned: true,
                iconTheme: Theme.of(context).iconTheme.copyWith(
                      color: this.getTextColor(altColor),
                    ),
                expandedHeight: this.getHeaderHeight(context),
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: this.getHeaderHeight(context) * .1),
                    child: SizedBox(
                      child: Center(
                        child: Image.network(
                          team.logos.first,
                        ),
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
                centerTitle: true,
                title: Text(
                  team.school,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: this.getTextColor(altColor)),
                ),
                bottom: TabBar(
                  onTap: (index) {
                    var pageName = "";
                    var index = DefaultTabController.of(context).index;
                    switch (index) {
                      case 0:
                        pageName = "Overview";
                        break;
                      case 1:
                        pageName = "Ratings";

                        break;
                      case 2:
                        pageName = "Schedule";

                        break;
                      default:
                    }
                    InheritedBlocs.of(context)
                        .analytics
                        .logEvent(name: "viewed_team_page", parameters: {
                      "team": team.school,
                      "team_page_name": pageName,
                    });
                  },
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Overview",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Ratings",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Schedule",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: this.getTextColor(altColor),
                            ),
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
          body: TabBarView(
            children: <Widget>[
              TeamOverview(team: team),
              TeamRatings(team: team, year: DateTime.now().year),
              TeamGames(
                team: team,
                year: DateTime.now().year,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getTextColor(Color color) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }

  double getHeaderHeight(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    double headerHeight = 200.0;
    double headerPercentage = .35;
    if ((deviceHeight * headerPercentage) > 200) {
      headerHeight = (deviceHeight * headerPercentage);
    }
    return headerHeight;
  }
}
