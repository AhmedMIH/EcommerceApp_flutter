import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../services//auth.dart';
import '../constants.dart';
import 'package:buy_it/provider/modelProgressHud.dart';
import 'package:buy_it/screens/user/home_screen.dart';
import 'package:buy_it/screens/login_screen.dart';
import 'package:buy_it/widgets/custom_textField.dart';
import 'package:buy_it/widgets/logoWidget.dart';

class SignUpScreen extends StatelessWidget {
  static String id = 'SignUpScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String _email, _password, _username;
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              LogoWidget(),
              SizedBox(
                height: height * 0.1,
              ),
              CustomTextField(
                onClick: (value) {
                  _email = value;
                },
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                onClick: (value) {
                  _username = value;
                },
                hint: 'Enter your username',
                icon: Icons.perm_identity,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              CustomTextField(
                onClick: (value) {
                  _password = value;
                },
                hint: 'Enter your password',
                icon: Icons.lock,
                obscureText: true,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 120),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () async {
                      _validate(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'already have a account ? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text(
                      'login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeIsLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      try {
        await _auth.signUp(_email.trim(), _password.trim());
        modelhud.changeIsLoading(false);
        Navigator.pushNamed(context, HomeScreen.id);
      } on PlatformException catch (e) {
        modelhud.changeIsLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message,
            ),
          ),
        );
      }
    }
    modelhud.changeIsLoading(false);
  }
}
