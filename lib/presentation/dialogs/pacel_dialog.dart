import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/screens/home/menu_screen_parcel.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/custom_text_without_icon.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PacelDialog extends StatefulWidget {
  String? orderType;
  String? orderIndex;
  PacelDialog({super.key, this.orderType, this.orderIndex});

  @override
  State<PacelDialog> createState() => _PacelDialogState();
}

class _PacelDialogState extends State<PacelDialog> {
  TextEditingController name = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.orderType);
    print(widget.orderIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeChangerProvider>(
      builder: (context, themeProvider, child) {
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
                    "Create Parcel Order",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  addHeight(30),
                  Text(
                    "Customer Name",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  addHeight(10),
                  CustomTextWithoutIcon(
                    controller: name,
                    hintText: "John Wick",
                  ),
                  addHeight(10),
                  Text(
                    "Mobile No",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  addHeight(10),
                  CustomTextWithoutIcon(
                    controller: mobileNo,
                    hintText: "Mobile No",
                  ),
                  addHeight(10),
                  Text(
                    "Address",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  addHeight(10),
                  CustomTextWithoutIcon(
                    controller: address,
                    hintText: "Address",
                  ),
                  addHeight(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MenuScreenParcel(
                          orderIndex: widget.orderIndex,
                          address: address.text,
                          mobileNo: mobileNo.text,
                          ordeType: widget.orderType,
                          name: name.text,
                        ),
                      ));
                    },
                    child: CustomButton(
                      width: MediaQuery.of(context).size.width * 0.45,
                      text: 'Create Order',
                      onPressed: () {},
                    ),
                  ),
                  addHeight(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
