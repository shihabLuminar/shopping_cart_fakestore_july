import 'package:flutter/material.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    title: "title",
                    desc: "desc",
                    qty: "qty",
                    image:
                        "https://images.pexels.com/photos/28518049/pexels-photo-28518049/free-photo-of-winter-wonderland-by-a-frozen-river.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    onIncrement: () {},
                    onDecrement: () {},
                    onRemove: () {},
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: 2)),
      ),
    );
  }
}
