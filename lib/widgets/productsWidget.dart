import 'package:buy_it/constants.dart';
import 'package:buy_it/models/Product.dart';
import 'package:buy_it/screens/user/productinfo_screen.dart';
import 'package:buy_it/services/store.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsWidget extends StatelessWidget {
  final Store _store = Store();
  final String category;
  ProductsWidget({
    @required this.category,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProductByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.size == 0) {
            return Center(
              child: Text(
                'Category is empty',
                style: TextStyle(fontSize: 25),
              ),
            );
          }
          List<Product> products = [];
          for (var doc in snapshot.data.docs) {
            var data = doc.data();
            products.add(
              Product(
                pId: doc.id,
                pName: data[kProductName],
                pPrice: data[kProductPrice],
                pLocation: data[kProductLocation],
                pDescription: data[kProductDescription],
                pCategory: data[kProductCategory],
              ),
            );
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductInfoScreen.id,
                      arguments: products[index]);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage(products[index].pLocation),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Opacity(
                        opacity: 0.6,
                        child: Container(
                          color: Colors.white,
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  products[index].pName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$ ${products[index].pPrice}',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            itemCount: products.length,
          );
        } else {
          return Center(
            child: Text('Loading...'),
          );
        }
      },
    );
  }
}
