import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/data/global/global_variable.dart';
import 'package:order_tracking/data/models/get_order_model.dart';
import 'package:order_tracking/presentation/provider/add_parcel_to_cart.dart';
import 'package:order_tracking/presentation/provider/add_to_cart.dart';
import 'package:order_tracking/presentation/provider/get_configuration_provider.dart';
import 'package:order_tracking/presentation/provider/get_order_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/screens/home/menu_screen_parcel.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/dashed_divider.dart';
import 'package:provider/provider.dart';
import 'package:order_tracking/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ParcelCart extends StatefulWidget {
  String? address;
  String? mobileNo;
  String? orderType;
  String? orderIndex;
  ParcelCart(
      {super.key,
      this.address,
      this.mobileNo,
      this.orderType,
      this.orderIndex});

  @override
  State<ParcelCart> createState() => _ParcelCartState();
}

class _ParcelCartState extends State<ParcelCart> {
  double? subtotal;
  var taxRate;
  String? date;
  var tax;
  
  double? total;
  bool isloading = false;
  String? selectedMode;
  List<String> orderMode = ['Phone Order', 'Home Delivery'];

  sendOrder() async {
    await GlobalVariable.loadIpAddress();
    setState(() {});
    final url =
        Uri.parse('${GlobalVariable.baseUrl}${GlobalVariable.postOrder}');

    List<CartItem> cartItems =
        Provider.of<AddParcelToCart>(context, listen: false).getCartItems();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var bId = sharedPreferences.getString('branchId');
    var userNo = sharedPreferences.getString('userno');

    List<BodyList> oldOrders =
        Provider.of<GetOrderProvider>(context, listen: false)
                .getOrderModel
                .bodyList ??
            [];

    List<dynamic> allItems = [...oldOrders, ...cartItems];
    setState(() {
      isloading = true;
    });

    // Map each item to a body list
    List<Map<String, dynamic>> bodyList = allItems.map((item) {
      bool isCartItem = item is CartItem;
      return {
        "OrderID": isCartItem ? 0 : (item as BodyList).orderId ?? 0,
        "OrderDate": date,
        "MenuID": isCartItem ? (item).menuId : (item as BodyList).menuId,
        "MenuName":
            isCartItem ? (item).productName : (item as BodyList).menuName,
        "Quantity": isCartItem ? (item).quantity : (item as BodyList).quantity,
        "Rate": isCartItem ? (item).rate : (item as BodyList).rate,
        "Instructions": isCartItem
            ? (item).instructions ?? ""
            : (item as BodyList).instructions ?? "",
        "BranchID": bId,
        "IsNew": isCartItem,
        "ChefID": 1,
        "MenuType": isCartItem ? (item).menuType : (item as BodyList).menuType,
      };
    }).toList();

    // Aggregate data across all cart items

    final customerNames =
        cartItems.map((item) => item.cusName).toSet().join(', ');
    final customeNo = cartItems.map((item) => item.mobileNo).toSet().join(', ');
    final customerAddress =
        cartItems.map((item) => item.address).toSet().join(', ');

    final orderId = oldOrders.isNotEmpty
        ? oldOrders.map((item) => item.orderId ?? 0).toSet().join(', ')
        : 0;

    final body = {
      "OrderID": orderId,
      "OrderDate": date,
      "SessionID": 1,
      "OrderMode": selectedMode,
      "TableNo": '',
      "Covers": '',
      "CustomerName": customerNames.isNotEmpty ? customerNames : null,
      "CustomerCellNo": customeNo,
      "CustomerAddress": customerAddress,
      "GrossAmt": subtotal,
      "ServiceCharges": '',
      "SalesTax": tax,
      "TotalAmt": total,
      "OStartBy": userNo,
      "BranchID": bId,
      "Tablename": '',
      "BodyList": bodyList,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode <= 400) {
        print('Order sent successfully');
        CustomToast.showToast(message: 'Order sent successfully');
        print('Response: ${response.body}');

        setState(() {
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
        print('Failed to send order. Status: ${response.statusCode}');
        CustomToast.showToast(message: 'Order sent failed');
        print('Response: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      CustomToast.showToast(message: 'Something went wrong');
      print('Error sending order: $e');
    }
  }

  ///////////////////////////////////////////////////////////////////////
  var bID;
  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bID = sharedPreferences.getString('branchId');
    date = sharedPreferences.getString('date');
  }

  @override
  void initState() {
    super.initState();
    loadData().then((_) {
      print("Branch Id is $bID");
      print("Address is ${widget.address}");
      print("index is ${widget.orderIndex}");

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AddToCart>(context, listen: false).loadCartFromPrefs();
        Provider.of<GetConfigurationProvider>(context, listen: false)
            .getConfig();
      });

      // Future.microtask(() {
      //   Provider.of<GetOrderProvider>(context, listen: false)
      //       .getOrder(widget.tableName, bID);
      // });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    subtotal = Provider.of<AddParcelToCart>(context).getSubtotal();

    taxRate = Provider.of<GetConfigurationProvider>(context)
            .getCpnfigurationModel
            .salesTax ??
        0.0;
    // serviceRate = Provider.of<GetConfigurationProvider>(context)
    //         .getCpnfigurationModel
    //         .serviceCharges ??
    //     0.0;

    tax = (taxRate / 100) * subtotal!;

    total = (subtotal ?? 0.0) + (tax ?? 0.0);

    return Consumer<AddParcelToCart>(
      builder: (BuildContext context, provider, child) {
        List<CartItem> cartItems = provider.getCartItems();

        List<dynamic> allItems = [
          ...cartItems,
        ];

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MenuScreenParcel(
                    ordeType: widget.orderType,
                    orderIndex: widget.orderIndex,
                  ),
                ));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            centerTitle: true,
            title: const Text(
              'Order Details',
              style: TextStyle(fontSize: 25),
            ),
          ),
          body: Consumer<ThemeChangerProvider>(
            builder: (context, themeProvider, child) {
              final bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Expanded(
                    child: allItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: allItems.length,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            itemBuilder: (context, index) {
                              var item = allItems[index];
                              var isCartItem = item is CartItem;
                              return GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          "Delete Item",
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        backgroundColor: isDarkMode
                                            ? const Color(0xff3C3D37)
                                            : Colors.white,
                                        content: Text(
                                          "Are you sure you want to delete this item?",
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              List<CartItem> currentCartItems =
                                                  List.from(
                                                      provider.getCartItems());
                                              if (index <
                                                  currentCartItems.length) {
                                                provider.deleteItem(index);
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "OK",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  color: isDarkMode
                                      ? const Color(0xff3C3D37)
                                      : Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                isCartItem
                                                    ? (item)
                                                        .productName
                                                        .toString()
                                                    : (item as BodyList)
                                                        .menuName
                                                        .toString(),
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 21,
                                                    fontWeight: FontWeight.w600,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    provider.decrementQuantity(
                                                        index);
                                                  },
                                                ),
                                                Text(
                                                  "x${isCartItem ? (item).quantity : (item as BodyList).quantity}",
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add,
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    provider.incrementQuantity(
                                                        index);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Note: ${isCartItem ? (item).instructions : (item as BodyList).instructions}",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: isDarkMode
                                                  ? Colors.grey[400]
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "Rs. ${isCartItem ? (item).rate : (item as BodyList).rate}",
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No items in cart",
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color:
                          isDarkMode ? const Color(0xff3C3D37) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.2)
                              : Colors.black12,
                          blurRadius: 5,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DashedDivider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Rs. ${subtotal!.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "GST(16%):",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Rs. ${tax.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            Text(
                              "Rs. ${total!.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
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
                                          "Order Mode",
                                          style: GoogleFonts.outfit(
                                            textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        addHeight(10),
                                        DropdownButtonFormField<String>(
                                          value: selectedMode,
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: isDarkMode
                                                  ? const Color(0xff2F302C)
                                                  : ConstantsColors
                                                      .filledColors,
                                              labelText: "Select Order Mode",
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
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: isDarkMode
                                                      ? Colors.white38
                                                      : Colors.grey.withOpacity(
                                                          0.15), // Muted white border
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: isDarkMode
                                                      ? Colors.white38
                                                      : Colors.grey.withOpacity(
                                                          0.15), // Muted white border
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              )),
                                          dropdownColor: isDarkMode
                                              ? const Color(0xff2F302C)
                                              : Colors.white,
                                          items:
                                              orderMode.map((String orderMode) {
                                            return DropdownMenuItem<String>(
                                              value: orderMode,
                                              child: Text(orderMode,
                                                  style: TextStyle(
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black)),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedMode = newValue;
                                            });
                                          },
                                        ),
                                        addHeight(15),
                                        isloading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    isDarkMode
                                                        ? Colors.orange
                                                        : Colors.orange,
                                                  ),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  await sendOrder();
                                                  Navigator.pop(context);
                                                  provider.clearCart();
                                                },
                                                child: CustomButton(
                                                  text: 'Post Order',
                                                  onPressed: () {},
                                                ),
                                              )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: CustomButton(
                            text: 'Proceed to order',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
