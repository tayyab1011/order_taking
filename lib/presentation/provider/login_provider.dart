import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:order_tracking/core/constants/switch_to_screen.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:order_tracking/presentation/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool _isloading = false;
  final LoginModel _loginModel = LoginModel();

  bool get isloading => _isloading;
  LoginModel get loginModel => _loginModel;

  Future<LoginModel> loginUser(
      String userName, String password, BuildContext context) async {
    try {
      await GlobalVariable.loadIpAddress();
      _isloading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(
          "${GlobalVariable.baseUrl}${GlobalVariable.loginUrl}userName=$userName&password=$password"));

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['UserNo'] != null && data['UserNo'] != 0) {
          //DateTime date = DateTime.parse(data['DayDates']);
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('userno', data['UserNo'].toString());
          prefs.setString('branchId', data['BranchID'].toString());
          if (data['DayDates'] != null) {
            try {
              List<String> dated = data['DayDates'].split('/');

              String orderDate =
                  DateTime.parse("${dated[2]}-${dated[1]}-${dated[0]}")
                      .toString()
                      .split(' ')[0];

              prefs.setString('date', orderDate);
            } catch (e) {
              prefs.setString('date', data['DayDates']);
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) =>
                      const SwitchToScreen(targetScreen: HomeScreen())),
            );
          });

          CustomToast.showToast(message: 'Login Successful');
          return LoginModel.fromJson(data);
        } else {
          CustomToast.showToast(
              message: 'User name and password maybe incorrect');
          return LoginModel.fromJson(data);
        }
      } else {
        CustomToast.showToast(message: 'Login Failed');
        return LoginModel.fromJson(data);
      }
    } catch (e) {
      CustomToast.showToast(
          message: 'Please Enter IP address first by click on "i" option ');
      return LoginModel();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
