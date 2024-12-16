import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_may/controller/cart_screen_controllerd.dart';
import 'package:shopping_cart_may/main.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<CartScreenController>().getAllItems();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartSreenProvider = context.watch<CartScreenController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Cart"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return CartItemWidget(
                    title: cartSreenProvider.cartItems[index]["name"],
                    desc:
                        cartSreenProvider.cartItems[index]["price"].toString(),
                    qty: cartSreenProvider.cartItems[index]["qty"].toString(),
                    image: cartSreenProvider.cartItems[index]["image"],
                    onIncrement: () {},
                    onDecrement: () {},
                    onRemove: () {},
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: cartSreenProvider.cartItems.length)),
      ),
    );
  }
}
