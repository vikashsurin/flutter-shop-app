import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/products_overview.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (context, auth, previousProducts) =>
              Products(auth.token, auth.userId, previousProducts!.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', '', []),
          update: (context, auth, previousOrders) =>
              Orders(auth.token, auth.userId!, previousOrders!.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: "My Shop ",
          theme: ThemeData(
              primarySwatch: Colors.purple, primaryColor: Colors.orangeAccent),
          // home: const ProductOverviewScreen(),
          // home: AuthScreen(),
          home: authData.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                  future: authData.tryAutoLogin(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
