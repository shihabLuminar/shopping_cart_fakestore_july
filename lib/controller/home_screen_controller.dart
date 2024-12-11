import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_cart_may/app_config.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoading = false;
  List categories = [];
  int selectedCategory = 0;

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

  Future<void> getProducts({String? category}) async {}

  void onCategorySelection({required int clickedIndex}) {
    selectedCategory = clickedIndex;
    print(selectedCategory);
    notifyListeners();
  }
}
