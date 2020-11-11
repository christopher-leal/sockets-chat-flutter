import 'package:flutter/material.dart';

class CustomTextFiel extends StatelessWidget {
  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final IconData icon;
  final TextEditingController textController;
  const CustomTextFiel({
    Key key,
    @required this.hintText,
    @required this.icon,
    @required this.textController,
    this.obscureText = false,
    this.keyboardType = TextInputType.emailAddress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  offset: Offset(0, 5),
                  blurRadius: 5.0)
            ]),
        child: TextField(
          controller: textController,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
              prefixIcon: Icon(icon),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: hintText),
        ));
  }
}
