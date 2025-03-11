import 'package:flutter/material.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/provider/get_all_tables_provide.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/provider/transfer_provider.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class TransferDialog extends StatefulWidget {
  String? orderId;
  String? orderMode;

  TransferDialog({super.key, this.orderId, this.orderMode});

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  String? date;
  String? userno;
  String? selectedTable;
  bool isCustomTable = false;
  TextEditingController customTableController = TextEditingController();
  var bID;
  Future<void> loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bID = sharedPreferences.getString('branchId');
    date = sharedPreferences.getString('date');
    userno = sharedPreferences.getString('userno');
  }

  int coverCount = 1;
  TextEditingController tableC = TextEditingController();
  TextEditingController covers = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    print(widget.orderId);
    print(widget.orderMode);
    covers.text = coverCount.toString(); // Initialize the cover count
    Future.microtask(() =>
        Provider.of<GetAllTablesProvider>(context, listen: false).getTables());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Consumer2<ThemeChangerProvider, GetAllTablesProvider>(
        builder: (context, provider, tableProvider, child) {
          bool isDarkMode = provider.themeMode == ThemeMode.dark;
          return Column(
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
              addHeight(10),
              Consumer<ThemeChangerProvider>(
                builder: (context, provider, child) {
                  bool isDarkMode = provider.themeMode == ThemeMode.dark;

                  return Text(
                    "Inser Table",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Change color dynamically
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
              addHeight(8),
              tableProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : tableProvider.tableNames.isEmpty
                      ? Text(
                          "No tables available",
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? const Color(0xff2F302C)
                                : ConstantsColors.filledColors,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.15),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SearchableDropdown<String>(
                              items: [
                                ...tableProvider.tableNames.map((String table) {
                                  return DropdownMenuItem<String>(
                                    value: table,
                                    child: Text(
                                      table,
                                      style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  );
                                }),
                                DropdownMenuItem<String>(
                                  value: "Custom",
                                  child: Text(
                                    "Custom Table",
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ],
                              menuBackgroundColor: isDarkMode
                                  ? const Color(0xff2F302C)
                                  : Colors.white,
                              value: selectedTable,
                              hint: Text(
                                "Select Table",
                                style: TextStyle(
                                    color:
                                        isDarkMode ? Colors.grey : Colors.grey),
                              ),
                              searchHint: "Search for a table",
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedTable = newValue;
                                });
                              },
                              isExpanded: true,
                              dialogBox: true,
                              selectedValueWidgetFn: (item) {
                                return Text(
                                  item ?? '',
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black),
                                );
                              },
                              underline: Container(),
                            ),
                          ),
                        ),
              addHeight(8),
              Consumer<ThemeChangerProvider>(
                builder: (context, provider, child) {
                  bool isDarkMode = provider.themeMode == ThemeMode.dark;

                  return Text(
                    "Insert Covers",
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Change color dynamically
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
              addHeight(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ConstantsColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (coverCount > 1) {
                            coverCount--;
                            covers.text = coverCount.toString();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: covers,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: isDarkMode
                            ? const Color(0xff2F302C)
                            : ConstantsColors.filledColors,
                        filled: true,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.5)
                                : Colors.black.withOpacity(0.15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.15),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          int? newCount = int.tryParse(value);
                          if (newCount != null && newCount > 0) {
                            coverCount = newCount;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: ConstantsColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          coverCount++;
                          covers.text = coverCount.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              addHeight(25),
              Provider.of<TransferProvider>(context).isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () async {
                        await Provider.of<TransferProvider>(context,
                                listen: false)
                            .transferOrderToDineIn(
                                orderId: widget.orderId.toString(),
                                orderDate: date,
                                branchId: bID,
                                orderMode: widget.orderMode,
                                tableNo: selectedTable,
                                covers: covers.text.toString(),
                                transferBy: userno);
                        Navigator.pop(context);
                        CustomToast.showToast(message: 'Order Transfered');
                      },
                      child: CustomButton(
                        text: 'Transfer',
                        onPressed: () async {},
                      ),
                    ),
              addHeight(15),
            ],
          );
        },
      ),
    );
  }
}
