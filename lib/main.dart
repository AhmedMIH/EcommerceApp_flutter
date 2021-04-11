import 'package:buy_it/provider/adminMode.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:buy_it/provider/modelProgressHud.dart';
import 'package:buy_it/screens/admin/addProduct_screen.dart';
import 'package:buy_it/screens/admin/admin_screen.dart';
import 'package:buy_it/screens/admin/editProduct_screen.dart';
import 'package:buy_it/screens/admin/manageProduct_screen.dart';
import 'package:buy_it/screens/admin/orderDetails_screen.dart';
import 'package:buy_it/screens/admin/viewOrders_screen.dart';
import 'package:buy_it/screens/user/cart_screen.dart';
import 'package:buy_it/screens/user/home_screen.dart';
import 'package:buy_it/screens/login_screen.dart';
import 'package:buy_it/screens/signup_screen.dart';
import 'package:buy_it/screens/user/productinfo_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ModelHud>(
          create: (context) => ModelHud(),
        ),
        ChangeNotifierProvider<CartItem>(
          create: (context) => CartItem(),
        ),
        ChangeNotifierProvider<AdminMode>(
          create: (context) => AdminMode(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: autoSignIn() ? HomeScreen.id : LoginScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignUpScreen.id: (context) => SignUpScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AdminScreen.id: (context) => AdminScreen(),
          AddProductScreen.id: (context) => AddProductScreen(),
          ManageProductScreen.id: (context) => ManageProductScreen(),
          EditProductScreen.id: (context) => EditProductScreen(),
          ProductInfoScreen.id: (context) => ProductInfoScreen(),
          CartScreen.id: (context) => CartScreen(),
          ViewOrdersScreen.id: (context) => ViewOrdersScreen(),
          OrderDetailsScreen.id: (context) => OrderDetailsScreen(),
        },
      ),
    );
  }

  bool autoSignIn() {
    User user = Auth().getUser();
    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
