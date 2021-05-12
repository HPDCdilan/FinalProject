import 'package:flutter/material.dart';

void openDialog(context, title, message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(50),
          elevation: 0,
          backgroundColor: Colors.white,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: new BorderSide(
                style: BorderStyle.none,
              )),
          children: <Widget>[
            Text(title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900)),
            SizedBox(
              height: 10,
            ),
            Text(message,
                style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            SizedBox(
              height: 30,
            ),
            Center(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Colors.blueAccent,
                child: Text(
                  'GO BACK',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        );
      });
}
