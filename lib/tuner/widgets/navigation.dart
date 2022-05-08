import "package:flutter/material.dart";
import "package:online_course/tuner/views/home_view.dart";
import "package:online_course/tuner/views/settings_view.dart";

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(
          icon: Icon(Icons.mic),
        ),
        Tab(
          icon: Icon(Icons.settings),
        ),
      ],
      labelColor: Theme.of(context).focusColor,
      unselectedLabelColor: Theme.of(context).focusColor.withAlpha(70),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.transparent,
    );
  }
}

class Views extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Scaffold(
          body: Home(),
          backgroundColor: Colors.orangeAccent,
        ),
        Scaffold(
          body: Settings(),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
