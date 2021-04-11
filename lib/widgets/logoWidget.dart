import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('images/icons/iconBuy.png'),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                'Buy it',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
