import 'package:flutter/material.dart';

class TeamItemCard extends StatelessWidget {
  final Widget child;

  const TeamItemCard({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(30.0, 40.0))),
      child: FractionallySizedBox(
        widthFactor: .9,
        child: this.child,
      ),
    );
  }
}
