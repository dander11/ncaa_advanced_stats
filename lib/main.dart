import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'Blocs/statsBloc.dart';
import 'Models/Models.dart';
import 'Utils/Utils.dart';
import 'Widgets/InheritedBlocs.dart';
import 'Widgets/Lists/ConferencesList.dart';
import 'Widgets/Lists/StandingsList.dart';
import 'Widgets/Routing/RouteArgs/RouteArgs.dart';
import 'Widgets/Routing/Router.dart';
import 'Widgets/TeamDetails/teamDetailsPage.dart';

void main() {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  runApp(InheritedBlocs(
      analytics: analytics,
      observer: observer,
      statsBloc: StatsBloc(),
      child: MyApp(analytics, observer)));
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  MyApp(this.analytics, this.observer);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          appBarTheme: AppBarTheme(
            color: Colors.white,
          ),
        ),
        navigatorObservers: [
          observer,
          //CustomRouteObserver(),
        ],
        onGenerateRoute: (settings) {
          if (settings.arguments == null ||
              !(settings.arguments is RouteArgBase)) {
            return generateRoute(
              RouteSettings(
                isInitialRoute: settings.isInitialRoute,
                name: settings.name,
                arguments: RouteArgBase(context),
              ),
            );
          }
          return generateRoute(settings);
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      var isLargeScreen = Utils.isLargeScreen(context);

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            bottom: TabBar(
              onTap: (index) {
                var pageName = "";
                switch (index) {
                  case 0:
                    pageName = "Conferences";
                    break;
                  case 1:
                    pageName = "Standings";

                    break;
                  default:
                }
                InheritedBlocs.of(context)
                    .analytics
                    .logEvent(name: "viewed_page", parameters: {
                  "page_name": pageName,
                });
              },
              tabs: <Widget>[
                Tab(
                  text: "Conferences",
                ),
                Tab(
                  text: "Standings",
                )
              ],
            ),
          ),
          body: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: TabBarView(
                  children: <Widget>[
                    ConferencesList(),
                    StandingsWidget(),
                  ],
                ),
              ),
              if (isLargeScreen)
                Flexible(
                  flex: 3,
                  child: StreamBuilder<Team>(
                      stream: InheritedBlocs.of(context).statsBloc.currentTeam,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? TeamDetailPage(
                                team: snapshot.data,
                              )
                            : Container();
                      }),
                )
            ],
          ),
        ),
      );
    });
  }
}
