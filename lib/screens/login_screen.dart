import 'package:buy_it/widgets/logoWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:buy_it/constants.dart';
import 'package:buy_it/provider/adminMode.dart';
import 'package:buy_it/provider/modelProgressHud.dart';
import 'package:buy_it/screens/signup_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_textField.dart';
import 'admin/admin_screen.dart';
import 'user/home_screen.dart';

class LoginScreen extends StatelessWidget {
  static String id = 'LoginScreen';
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final adminPassword = '123456';
  String _email, _password;
  bool isAdmin = false;
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
                      'Login',
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
                    'Don\'t have a account ? ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignUpScreen.id);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(true);
                        },
                        child: Text(
                          'i\'am an admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? KMainColor
                                  : Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(context, listen: false)
                              .changeIsAdmin(false);
                        },
                        child: Text(
                          'i\'am an user',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.white
                                  : KMainColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelHub = Provider.of<ModelHud>(context, listen: false);
    modelHub.changeIsLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (_password == adminPassword) {
          try {
            await _auth.login(_email, _password);
            Navigator.pushNamed(context, AdminScreen.id);
          } catch (e) {
            modelHub.changeIsLoading(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message),
              ),
            );
          }
        } else {
          modelHub.changeIsLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('password is incorrect'),
            ),
          );
        }
      } else {
        try {
          await _auth.login(_email, _password);
          Navigator.pushNamed(context, HomeScreen.id);
        } catch (e) {
          modelHub.changeIsLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message),
            ),
          );
        }
      }
    }
    modelHub.changeIsLoading(false);
  }
}
