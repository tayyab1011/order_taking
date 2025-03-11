import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/get_cheif.dart';
import 'package:http/http.dart'as http;

class GetCheifProvider extends ChangeNotifier{
  bool _isLoading = false;
  List<GetCheifModel> _cheifs = [];
  bool get isLoading => _isLoading;

  List<String> get cheifNames => _cheifs.map((cheif)=>cheif.chefName?? '').toList();
  List<int?> get cheifId => _cheifs.map((id)=>id.id).toList();

  Future<void> getChiefs()async{
    await GlobalVariable.loadIpAddress();
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('${GlobalVariable.baseUrl}${GlobalVariable.cheifs}'));
      List<dynamic> data = jsonDecode(response.body);
      if(response.statusCode == 200){
        _cheifs = data.map((val)=>GetCheifModel.fromJson(val)).toList();
      }
      else{
        _cheifs = [];
      }
    } catch (e) {
      _cheifs = [];
      
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}