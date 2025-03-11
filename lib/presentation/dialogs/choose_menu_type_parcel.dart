import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/data/models/cart_model.dart';
import 'package:order_tracking/presentation/provider/add_parcel_to_cart.dart';

import 'package:order_tracking/presentation/provider/get_cheif_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';

import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/custom_text_without_icon.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChooseMenuTypeParcel extends StatefulWidget {
  String? prodName;
  double? rate;
  String? address;
  String? mobileNo;
  String? quntity;
  String? cusName;

  String? menuId;
  String? orderType;

  ChooseMenuTypeParcel({
    super.key,
    this.mobileNo,
    this.address,
    this.rate,
    this.prodName,
    this.quntity,
    this.menuId,
    this.cusName,
    this.orderType,
  });

  @override
  State<ChooseMenuTypeParcel> createState() => _ChooseMenuTypeParcelState();
}

class _ChooseMenuTypeParcelState extends State<ChooseMenuTypeParcel> {
  String? selectedMenu;
  
  TextEditingController inst = TextEditingController();
  String? selectCheif;
  List<String> menus = ['None', 'Fresh', 'Half Done'];
  List<String> orderMode = ['Phone Order', 'Home Delivery'];

  @override
void initState() {
  super.initState();
  Future.microtask(() =>
      Provider.of<GetCheifProvider>(context, listen: false).getChiefs());

  selectedMenu = null;
  selectCheif = null;
  inst.clear(); // Clear instructions text field

  print(widget.cusName);
  print(widget.orderType);
  print(widget.mobileNo);
  print(widget.address);
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
      setState(() {
        selectedMenu = null;
        selectCheif = null;
        inst.clear();
      });
      return true;
    },
      child: Consumer2<GetCheifProvider, ThemeChangerProvider>(
        builder: (BuildContext context, provider, themeProvider, Widget? child) {
          bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
          return Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Image.asset(
                            'assets/images/close.png',
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Menu",
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    addHeight(10),
                    DropdownButtonFormField<String>(
                      value: selectedMenu,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode
                              ? const Color(0xff2F302C)
                              : ConstantsColors.filledColors,
                          labelText: "Select Menu",
                          labelStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white38
                                  : Colors.grey
                                      .withOpacity(0.15), // Muted white border
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white38
                                  : Colors.grey
                                      .withOpacity(0.15), // Muted white border
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isDarkMode
                                  ? Colors.white38
                                  : Colors.grey
                                      .withOpacity(0.15), // Muted white border
                            ),
                            borderRadius: BorderRadius.circular(30),
                          )),
                      dropdownColor:
                          isDarkMode ? const Color(0xff2F302C) : Colors.white,
                      items: menus.map((String food) {
                        return DropdownMenuItem<String>(
                          value: food,
                          child: Text(food,
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMenu = newValue;
                        });
                      },
                    ),
                    addHeight(10),
                    
      
                    
                    Text(
                      "Cheff",
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    addHeight(10),
                    provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : provider.cheifNames.isEmpty
                            ? Text("No cheffs available",
                                style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.white : Colors.black))
                            : DropdownButtonFormField<String>(
                                value: selectCheif,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white38
                                          : Colors.grey.withOpacity(
                                              0.15), // Muted white border
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white38
                                          : Colors.grey.withOpacity(
                                              0.15), // Muted white border
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  filled: true,
                                  fillColor: isDarkMode
                                      ? const Color(0xff2F302C)
                                      : ConstantsColors.filledColors,
                                  labelText: "Select Cheff",
                                  labelStyle: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isDarkMode
                                          ? Colors.white38
                                          : Colors.grey.withOpacity(
                                              0.15), // Muted white border
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                dropdownColor: isDarkMode
                                    ? const Color(0xff2F302C)
                                    : Colors.white,
                                items: provider.cheifNames.map((String food) {
                                  return DropdownMenuItem<String>(
                                    value: food,
                                    child: Text(food,
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectCheif = newValue;
                                  });
                                },
                              ),
                    addHeight(20),
                    Text(
                      "Instructions",
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    addHeight(10),
                    CustomTextWithoutIcon(
                      controller: inst,
                      hintText: "eg. Add extra sauce",
                      lines: 3,
                    ),
                    addHeight(23),
                    GestureDetector(
        onTap: () {
      CartItem cartItem = CartItem(
        productName: widget.prodName,
        address: widget.address,
        mobileNo: widget.mobileNo,
        rate: widget.rate,
        instructions: inst.text,
        quantity: widget.quntity,
        cusName: widget.cusName,
        orderType: widget.orderType,
        chief: selectCheif,
        menuType: selectedMenu,
        menuId: widget.menuId,
      );
      Provider.of<AddParcelToCart>(context, listen: false).addItem(cartItem);
      
      setState(() {}); // Force rebuild to reset UI state
      
      Navigator.pop(context);
      CustomToast.showToast(message: 'Added To Cart');
        },
        child: CustomButton(text: 'ADD TO CART', onPressed: () {}),
      ),
      
                    addHeight(20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
