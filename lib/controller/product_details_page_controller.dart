import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';
import 'package:shopping_cart_may/models/product_model.dart';

class ProductDetailsPageController with ChangeNotifier {
  ProductModel? selectedProduct;
  bool isLoading = false;

  Future<void> getProductDetails(String productId) async {
    final url = Uri.parse(AppConfig.baseUrl + "products/$productId");
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        selectedProduct = ProductModel.fromJson(jsonDecode(response.body));
        // selectedProduct = singleProudctMoldelFromJson(response.body);
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }
}
