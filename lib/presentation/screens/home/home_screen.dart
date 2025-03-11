import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/dialogs/order_list_dialog.dart';
import 'package:order_tracking/presentation/dialogs/pacel_dialog.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/screens/auth/sign_in.dart';
import 'package:order_tracking/presentation/screens/home/bluetooth_screen.dart';
import 'package:order_tracking/presentation/screens/home/pending_order_screen.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedContainerIndex;
  String? selectedOrderType;

  void naviGateToScreen() {
    if (selectedContainerIndex != null && selectedOrderType != null) {
      if (selectedContainerIndex == 0 && selectedOrderType == 'Dine In') {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: SingleChildScrollView(
                      child: OrderListDialog(
                orderType: selectedOrderType,
                orderIndex: selectedContainerIndex.toString(),
              )));
            });
      } else if (selectedContainerIndex == 0 && selectedOrderType == 'Parcel') {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: SingleChildScrollView(
                      child: PacelDialog(
                orderType: selectedOrderType,
                orderIndex: selectedContainerIndex.toString(),
              )));
            });
      } else if (selectedContainerIndex == 1 &&
          selectedOrderType == 'Dine In') {
        showDialog(
            context: context,
            builder: (context) {
              return Center(
                  child: SingleChildScrollView(
                      child: OrderListDialog(
                orderType: selectedOrderType,
                orderIndex: selectedContainerIndex.toString(),
              )));
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text("Home"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
        ),
        body: Consumer<ThemeChangerProvider>(
          builder: (context, themeProvider, child) {
            bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<int>(
                    value: 0,
                    groupValue: selectedContainerIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedContainerIndex = value;
                      });
                    },
                    title: Text(
                      'GST with service charge',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: selectedContainerIndex == 0
                              ? Colors.white
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    activeColor: Colors.white,
                    tileColor: selectedContainerIndex == 0
                        ? ConstantsColors.primary
                        : isDarkMode
                            ? Colors.grey[700]
                            : Colors.orange.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  addHeight(10),
                  RadioListTile<int>(
                    value: 1,
                    groupValue: selectedContainerIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedContainerIndex = value;
                      });
                    },
                    title: Text(
                      'GST without service charge',
                      style: GoogleFonts.outfit(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: selectedContainerIndex == 1
                              ? Colors.white
                              : (isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    activeColor: Colors.white,
                    tileColor: selectedContainerIndex == 1
                        ? ConstantsColors.primary
                        : isDarkMode
                            ? Colors.grey[700]
                            : Colors.orange.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  addHeight(20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOrderType = 'Dine In';
                                    naviGateToScreen();
                                  });
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/dine.png',
                                      height: 24,
                                      color: selectedOrderType == 'Dine In'
                                          ? ConstantsColors.primary
                                          : (isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    Text(
                                      'Dine In',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: selectedOrderType == 'Dine In'
                                              ? ConstantsColors.primary
                                              : (isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOrderType = 'Parcel';
                                    naviGateToScreen();
                                  });
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/parcel.png',
                                      color: selectedOrderType == 'Parcel'
                                          ? ConstantsColors.primary
                                          : (isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                      height: 24,
                                    ),
                                    Text(
                                      'Parcel',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: selectedOrderType == 'Parcel'
                                              ? ConstantsColors.primary
                                              : (isDarkMode
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => BluetoothScreen()));
                                },
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/printers.png',
                                      height: 24,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    Text(
                                      'Bluetooth',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 16,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  addHeight(20),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PendingOrderScreen()));
                      },
                      child: CustomButton(
                          text: 'Pending Orders', onPressed: () {}))
                ],
              ),
            );
          },
        ));
  }
}
