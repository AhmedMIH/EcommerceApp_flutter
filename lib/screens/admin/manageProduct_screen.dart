import 'package:buy_it/constants.dart';
import 'package:buy_it/models/Product.dart';
import 'package:buy_it/screens/admin/editProduct_screen.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custome_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProductScreen extends StatefulWidget {
  static String id = 'ManageProductScreen';

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadAllProduct(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                  onTapUp: (details) {
                    double positionFromLeft = details.globalPosition.dx;
                    double positionFromTop = details.globalPosition.dy;
                    double positionFromRight =
                        MediaQuery.of(context).size.width - positionFromLeft;
                    double positionFromBottom =
                        MediaQuery.of(context).size.height - positionFromTop;
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                          positionFromLeft,
                          positionFromTop,
                          positionFromRight,
                          positionFromBottom),
                      items: [
                        MyPopupMenuItem(
                          onClick: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, EditProductScreen.id,
                                arguments: products[index]);
                          },
                          child: Text('Edit'),
                        ),
                        MyPopupMenuItem(
                          onClick: () {
                            _store.deleteProduct(products[index].pId);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          image: AssetImage('images/icons/iconBuy.png'),
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
      ),
    );
  }
}
