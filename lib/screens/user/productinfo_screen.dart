import 'package:buy_it/constants.dart';
import 'package:buy_it/models/Product.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfoScreen extends StatefulWidget {
  static String id = 'ProductInfoScreen';
  @override
  _ProductInfoScreenState createState() => _ProductInfoScreenState();
}

class _ProductInfoScreenState extends State<ProductInfoScreen> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    Product _product = ModalRoute.of(context).settings.arguments;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: statusBarHeight),
                height: height * 0.6,
                width: width,
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(_product.pLocation),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: width,
                      height: height * 0.27,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _product.pName,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _product.pDescription,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\$${_product.pPrice}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Material(
                                    color: KMainColor,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_quantity > 1) {
                                            _quantity--;
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        child: Center(
                                          child: Icon(Icons.remove),
                                        ),
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    _quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ClipOval(
                                  child: Material(
                                    color: KMainColor,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _quantity++;
                                        });
                                      },
                                      child: SizedBox(
                                        child: Center(
                                          child: Icon(Icons.add),
                                        ),
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size(width, height * 0.1),
                          backgroundColor: KMainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          addToCart(_product);
                        },
                        child: Text(
                          'Add To Cart',
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
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
        ],
      ),
    );
  }

  void addToCart(
    Product product,
  ) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    product.pQuantity = _quantity;
    var productsInCart = cartItem.products;
    bool exist = false;
    for (var productInCart in productsInCart) {
      if (productInCart.pName == product.pName) {
        exist = true;
      }
    }
    if (!exist) {
      cartItem.addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added To Cart'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('item already added to the cart before'),
        ),
      );
    }
  }
}
