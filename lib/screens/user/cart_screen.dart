import 'package:buy_it/constants.dart';
import 'package:buy_it/models/Product.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/screens/user/productinfo_screen.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custome_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id = 'CartScreen';
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(color: Colors.black),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          LayoutBuilder(builder: (context, constrains) {
            if (products.isNotEmpty) {
              return Container(
                height: screenHeight -
                    statusBarHeight -
                    appBarHeight -
                    (screenHeight * .13),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTapUp: (details) {
                          showCustomeMenu(details, context, products[index]);
                        },
                        child: Container(
                          height: screenHeight * .15,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: screenHeight * .15 / 2,
                                backgroundImage:
                                    AssetImage(products[index].pLocation),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            products[index].pName,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            '\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Text(
                                        products[index].pQuantity.toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          color: KSecondaryColor,
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              );
            } else {
              return Container(
                height: screenHeight -
                    (screenHeight * .13) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text(
                    'Cart is Empty',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
              );
            }
          }),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextButton(
              onPressed: products.isEmpty
                  ? null
                  : () {
                      showCustomeDialog(products, context);
                    },
              style: TextButton.styleFrom(
                minimumSize: Size(screenWidth, screenHeight * 0.1),
                backgroundColor: KMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Order'.toUpperCase(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showCustomeMenu(details, context, product) async {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.width - dy;
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfoScreen.id,
                  arguments: product);
            },
            child: Text('Edit'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }

  void showCustomeDialog(List<Product> products, context) async {
    var price = getTotallPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            if (address == null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('plase enter your address'),
              ));
            } else {
              try {
                Store _store = Store();
                _store.storeOrders(
                    {kTotalPrice: price, kAddress: address}, products);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Orderd Successfully'),
                ));
                Navigator.pop(context);
              } catch (ex) {
                print(ex.message);
              }
            }
          },
          child: Text('Confirm'),
        ),
        MaterialButton(
          onPressed: () {
            try {
              Navigator.pop(context);
            } catch (ex) {
              print(ex.message);
            }
          },
          child: Text('Cancel'),
        )
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter your Address'),
      ),
      title: Text('Totall Price  = \$ $price'),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotallPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += product.pQuantity * int.parse(product.pPrice);
    }
    return price;
  }
}
