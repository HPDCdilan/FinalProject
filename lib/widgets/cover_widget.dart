import 'package:flutter/material.dart';

class CoverWidget extends StatelessWidget {
  final widget;
  const CoverWidget({Key key, @required this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.05,
        ),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    'https://img.freepik.com/free-vector/white-abstract-background_23-2148810113.jpg?size=626&ext=jpg&ga=GA1.2.1348306104.1615852800'),
                fit: BoxFit.cover)),
        child: widget);
  }
}
