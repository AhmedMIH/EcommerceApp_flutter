import 'package:buy_it/models/Product.dart';
import 'package:buy_it/widgets/modifyProductWidget.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  static String id = 'EditProductScreen';

  @override
  Widget build(BuildContext context) {
    Product _product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: ModifyProductWidget(
        buttonName: 'Edit Product',
        product: _product,
      ),
    );
  }
}
