import 'package:buy_it/widgets/modifyProductWidget.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  static String id = 'AddProductScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModifyProductWidget(
        buttonName: 'Add Product',
      ),
    );
  }
}
