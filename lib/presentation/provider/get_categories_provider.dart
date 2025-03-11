import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/category_model.dart';
import 'package:http/http.dart'as http;

class GetCategoriesProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<CatagoriesModel> _categories = [];
  bool get isLoading => _isLoading;

  List<String> get categoryName => _categories.map((category)=>category.name?? '').toList();
  List<int?> get catId => _categories.map((category)=>category.catId).toList();

  Future<void> getCategory() async{
    await GlobalVariable.loadIpAddress();
    _isLoading = true;
    notifyListeners();
   try {
      final response = await http.get(Uri.parse("${GlobalVariable.baseUrl}${GlobalVariable.category}"));
    List<dynamic> data = jsonDecode(response.body);
    if(response.statusCode ==200){
      _categories = data.map((value)=>CatagoriesModel.fromJson(value)).toList();
    }
    else{
      _categories = [];
    }
   } catch (e) {
    _categories = [];
     
   }
   finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}