import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String route;
  final String primaryText;
  final String secondaryText;

  const Labels(
      {Key key,
      @required this.route,
      @required this.primaryText,
      @required this.secondaryText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            secondaryText,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, route),
            child: Text(
              primaryText,
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
