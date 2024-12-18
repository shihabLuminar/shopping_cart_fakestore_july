import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_web/razorpay_web.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shopping_cart_may/controller/cart_screen_controllerd.dart';
import 'package:shopping_cart_may/view/cart_screen/widgets/cart_item_widget.dart';
import 'package:shopping_cart_may/view/home_screen/home_screen.dart';

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
                    onIncrement: () {
                      context.read<CartScreenController>().incrementQty(
                          cartSreenProvider.cartItems[index]["qty"],
                          cartSreenProvider.cartItems[index]["id"]);
                    },
                    onDecrement: () {
                      context.read<CartScreenController>().decrementQty(
                          cartSreenProvider.cartItems[index]["qty"],
                          cartSreenProvider.cartItems[index]["id"]);
                    },
                    onRemove: () async {
                      await context.read<CartScreenController>().removeAnItem(
                          cartSreenProvider.cartItems[index]["id"]);
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
                itemCount: cartSreenProvider.cartItems.length)),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            height: 80,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total : ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      "₹ ${cartSreenProvider.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  ],
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      Razorpay razorpay = Razorpay();
                      var options = {
                        'key': 'rzp_test_1DP5mmOlF5G5ag',
                        'amount': cartSreenProvider.totalPrice * 100,
                        'name': 'Acme Corp.',
                        'description': 'Fine T-Shirt',
                        'retry': {'enabled': true, 'max_count': 1},
                        'send_sms_hash': true,
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'test@razorpay.com'
                        },
                        'external': {
                          'wallets': ['paytm']
                        },
                        'timeout': 120,
                        'theme.color': '#BFECFF',
                      };
                      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse);
                      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse);
                      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected);
                      razorpay.open(options);
                    },
                    child: Text("Pay Now"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    // /*
    // * Payment Success Response contains three values:
    // * 1. Order ID
    // * 2. Payment ID
    // * 3. Signature
    // * */
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
      (route) => false,
    );
    showAlertDialog(context, "Payment Successful",
        "Payment ID: ${response.paymentId}\nPayment ID: ${response.signature} \nPayment ID: ${response.orderId} ");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
