import 'package:buy_it/constants.dart';
import 'package:buy_it/screens/admin/addProduct_screen.dart';
import 'package:buy_it/screens/admin/manageProduct_screen.dart';
import 'package:buy_it/screens/admin/viewOrders_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  static String id = 'AdminScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AddProductScreen.id);
            },
            child: Text('Add Product'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ManageProductScreen.id);
            },
            child: Text('Edit Product'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ViewOrdersScreen.id);
            },
            child: Text('View orders'),
          ),
        ],
      ),
    );
  }
}
