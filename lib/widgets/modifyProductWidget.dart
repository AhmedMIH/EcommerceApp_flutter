import 'package:buy_it/constants.dart';
import 'package:buy_it/models/Product.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textField.dart';
import 'package:flutter/material.dart';

class ModifyProductWidget extends StatelessWidget {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  Product product = new Product(pCategory: '');
  String _category;
  String _desc;
  String _location;
  String _name;
  String _price;
  final String buttonName;
  Store _store = Store();
  ModifyProductWidget({
    this.product,
    @required this.buttonName,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Column(
              children: [
                CustomTextField(
                  hint: 'Product Name',
                  initialValue: product == null ? null : product.pName,
                  onClick: (value) {
                    _name = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Price',
                  initialValue: product == null ? null : product.pPrice,
                  onClick: (value) {
                    _price = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Description',
                  initialValue: product == null ? null : product.pDescription,
                  onClick: (value) {
                    _desc = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Category',
                  initialValue: product == null ? null : product.pCategory,
                  onClick: (value) {
                    _category = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  hint: 'Product Location',
                  initialValue: product == null ? null : product.pLocation,
                  onClick: (value) {
                    _location = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () async {
                        if (_globalKey.currentState.validate()) {
                          _globalKey.currentState.save();
                          try {
                            switch (buttonName) {
                              case 'Add Product':
                                {
                                  await _store.addProduct(
                                    Product(
                                        pName: _name,
                                        pPrice: _price,
                                        pDescription: _desc,
                                        pLocation: _location,
                                        pCategory: _category),
                                  );
                                }
                                break;
                              case 'Edit Product':
                                product.pCategory = _category;
                                product.pDescription = _desc;
                                product.pLocation = _location;
                                product.pName = _name;
                                product.pPrice = _price;
                                await _store.editProduct(product);
                                break;
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      child: Text(
                        buttonName,
                        style: TextStyle(
                          color: KSecondaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () {
                        _globalKey.currentState.reset();
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: KSecondaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
