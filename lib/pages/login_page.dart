import 'package:flutter/material.dart';
import 'package:realtime_chat/widgets/blue_button.dart';
import 'package:realtime_chat/widgets/labels.dart';
import 'package:realtime_chat/widgets/logo.dart';
import 'package:realtime_chat/widgets/text-field.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    title: 'Messenger',
                  ),
                  _Form(),
                  Labels(
                    route: 'register',
                    secondaryText: '¿No tienes cuenta?',
                    primaryText: 'Crear una ahora',
                  ),
                  Container(
                    child: Text(
                      'Terminos y condiciones',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [
          CustomTextFiel(
            hintText: 'Email',
            icon: Icons.mail_outline,
            textController: emailController,
          ),
          CustomTextFiel(
            hintText: 'Password',
            icon: Icons.lock_open,
            obscureText: true,
            keyboardType: TextInputType.text,
            textController: passwordController,
          ),
          BlueButton(
            text: 'Ingresar',
            onPressed: () {
              print(emailController.text);
            },
          )
          // TextField(),
        ],
      ),
    );
  }
}
