import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controller/cart_screen_controllerd.dart';
import 'package:shopping_cart_may/controller/home_screen_controller.dart';
import 'package:shopping_cart_may/controller/product_details_page_controller.dart';
import 'package:shopping_cart_may/view/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CartScreenController.initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenController()),
        ChangeNotifierProvider(create: (context) => CartScreenController()),
        ChangeNotifierProvider(
            create: (context) => ProductDetailsPageController())
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
