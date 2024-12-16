import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class CartScreenController with ChangeNotifier {
  static late Database database;
  List<Map> cartItems = [];

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
    required int productId,
    required String name,
    required String des,
    required String imgurl,
    required double price,
  }) async {
    await database.rawInsert(
        'INSERT INTO Cart(name, qty, price, image, des, productId) VALUES(?, ?, ?, ?, ?, ?)',
        [name, 1, price, imgurl, des, productId]);

    await getAllItems();
  }

  Future getAllItems() async {
    cartItems = await database.rawQuery('SELECT * FROM Cart');
    log(cartItems.toString());
    notifyListeners();
  }

  removeAnItem() {}
  decrementQty() {}
  incrementQty() {}
}
