import 'package:buy_it/constants.dart';
import 'package:buy_it/screens/login_screen.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/productsWidget.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = Auth();
  User _loggedUser;
  int _tabBarindex = 0;
  int _bottomBarindex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _bottomBarindex,
              fixedColor: KMainColor,
              onTap: (value) async {
                if (value == 2) {
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                }
                setState(() {
                  _bottomBarindex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  label: 'Person',
                  icon: Icon(
                    Icons.person,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Person',
                  icon: Icon(
                    Icons.person,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'SignOut',
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: KMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarindex = value;
                  });
                },
                tabs: [
                  Text(
                    'Jackets',
                    style: TextStyle(
                      color: _tabBarindex == 0 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarindex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Trouser',
                    style: TextStyle(
                      color: _tabBarindex == 1 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarindex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'T-shirts',
                    style: TextStyle(
                      color: _tabBarindex == 2 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarindex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Shoes',
                    style: TextStyle(
                      color: _tabBarindex == 3 ? Colors.black : kUnActiveColor,
                      fontSize: _tabBarindex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                ProductsWidget(category: kJackets),
                ProductsWidget(category: kTrousers),
                ProductsWidget(category: kTshirts),
                ProductsWidget(category: kShoes),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                    child: Icon(
                      Icons.shopping_cart,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getCurrentUser();
  }

  getCurrentUser() {
    _loggedUser = _auth.getUser();
  }
}
