import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;

  const Logo({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170.0,
        // margin: EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Image(image: AssetImage('assets/tag-logo.png')),
            SizedBox(height: 20.0),
            Text(
              title,
              style: TextStyle(fontSize: 30.0),
            )
          ],
        ),
      ),
    );
  }
}
