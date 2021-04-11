import 'package:buy_it/constants.dart';
import 'package:buy_it/models/order.dart';
import 'package:buy_it/screens/admin/orderDetails_screen.dart';
import 'package:buy_it/services/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewOrdersScreen extends StatelessWidget {
  static String id = 'ViewOrderScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('there is no orders'),
            );
          } else {
            List<Order> orders = [];
            for (var doc in snapshot.data.docs) {
              var data = doc.data();

              orders.add(Order(
                documentId: doc.id,
                address: data[kAddress],
                totallPrice: data[kTotalPrice],
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsScreen.id,
                        arguments: orders[index].documentId);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    color: KSecondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Totall Price = \$${orders[index].totallPrice}',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Address is ${orders[index].address}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }
}
