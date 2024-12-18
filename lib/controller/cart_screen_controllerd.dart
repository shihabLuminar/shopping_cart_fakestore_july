import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class CartScreenController with ChangeNotifier {
  static late Database database;
  List<Map> cartItems = [];
  double totalPrice = 0.0;

  static Future<void> initDb() async {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    }

    database = await openDatabase(
      "cart.db",
      version: 1,
      onCreate: (db, version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, price REAL, image TEXT, des TEXT, productId INTEGER)');
      },
    );
  }

  Future addItem({
    required BuildContext context,
    required int productId,
    required String name,
    required String des,
    required String imgurl,
    required double price,
  }) async {
    await getAllItems(); // get all items after adding items to cart

    log("initial : " + cartItems.toString());
    bool alreadyInCart =
        false; //  if true item already inthe cart so  dont want to add it agian
    for (int i = 0; i < cartItems.length; i++) {
      // checking whether the clicked product id is aready in cart or not
      if (cartItems[i]["productId"] == productId) {
        alreadyInCart = true; // setting value true if item already in cart
        log(alreadyInCart.toString());
      }
    }
    log("alreadyInCart = " + alreadyInCart.toString());

    if (alreadyInCart == false) {
      // if item not in cart add to cart
      await database.rawInsert(
          'INSERT INTO Cart(name, qty, price, image, des, productId) VALUES(?, ?, ?, ?, ?, ?)',
          [name, 1, price, imgurl, des, productId]);
      // show succes snackbar

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green, content: Text("item added to cart")));
    } else {
      // show item in cart snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Already in cart")));
    }

    notifyListeners();
  }

  Future getAllItems() async {
    cartItems = await database.rawQuery('SELECT * FROM Cart');
    // log(cartItems.toString());
    calculateTotal();
    notifyListeners();
  }

  removeAnItem(int id) async {
    await database.rawDelete('DELETE FROM Cart WHERE id = ?', [id]);
    getAllItems();
    notifyListeners();
  }

  Future<void> decrementQty(int qty, int id) async {
    if (qty >= 2) {
      qty--;
      await database
          .rawUpdate('UPDATE Cart SET qty = ? WHERE id = ?', [qty, id]);
      await getAllItems();
    }
  }

  Future<void> incrementQty(int qty, int id) async {
    qty++;
    await database.rawUpdate('UPDATE Cart SET qty = ? WHERE id = ?', [qty, id]);
    await getAllItems();
  }

  void calculateTotal() {
    totalPrice = 0.0;
    for (int i = 0; i < cartItems.length; i++) {
      double currentItemPrice = cartItems[i]["price"] * cartItems[i]["qty"];

      totalPrice = totalPrice + currentItemPrice;
    }
    notifyListeners();
  }
}
