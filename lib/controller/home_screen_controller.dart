import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';
import 'package:shopping_cart_may/models/product_model.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoading = false;
  bool isProductsLoading = false;
  List categories = [];
  int selectedCategoryIndex = 0;
  List<ProductModel> productsList = [];

//fetch categories form api
  Future<void> getCategories() async {
    final url = Uri.parse(AppConfig.baseUrl + "products/categories");
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        categories = jsonDecode(response.body);
        categories.insert(0, "all"); // TO ADD "ALL" CATEGORY TO CATEGORY LIST
      }
    } catch (e) {
      print(e);
    }
    isLoading = false;
    notifyListeners();
  }

// for fetching all products and product by category
  Future<void> getProducts({String? category}) async {
    String endpinturl =
        category == null ? "products" : "products/category/$category";
    final url = Uri.parse(AppConfig.baseUrl + endpinturl);
    log(url.toString());
    try {
      isProductsLoading = true;
      notifyListeners();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        productsList = productModelFromJson(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
    isProductsLoading = false;
    notifyListeners();
  }

  void onCategorySelection({required int clickedIndex}) {
    selectedCategoryIndex = clickedIndex;
    print(selectedCategoryIndex);
    getProducts(
        category: selectedCategoryIndex == 0
            ? null
            : categories[selectedCategoryIndex]);
    notifyListeners();
  }
}
