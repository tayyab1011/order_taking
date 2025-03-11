import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';
import 'package:order_tracking/presentation/provider/get_all_tables_provide.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/screens/home/menu_screen.dart';
import 'package:order_tracking/presentation/widgets/custom_button.dart';
import 'package:order_tracking/presentation/widgets/custom_text_without_icon.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OrderListDialog extends StatefulWidget {
  String? orderType;
  String? orderIndex;
  OrderListDialog({super.key, this.orderType, this.orderIndex});

  @override
  State<OrderListDialog> createState() => _OrderListDialogState();
}

class _OrderListDialogState extends State<OrderListDialog> {
  String? selectedTable;
  bool isCustomTable = false;
  int coverCount = 1; // Default count
  TextEditingController name = TextEditingController();
  TextEditingController customTableController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.orderType);
    print(widget.orderIndex);
    _controller.text = coverCount.toString(); // Initialize the cover count
    Future.microtask(() =>
        Provider.of<GetAllTablesProvider>(context, listen: false).getTables());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GetAllTablesProvider, ThemeChangerProvider>(
      builder: (BuildContext context, provider, themeProvider, child) {
        bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

        return AlertDialog(
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
                "Create New Order",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              addHeight(30),
              Text(
                "Customer Name",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
                "Covers",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              addHeight(10),
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
                            _controller.text = coverCount.toString();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _controller,
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
                          _controller.text = coverCount.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              addHeight(20),
              Text(
                "Choose Table",
                style: GoogleFonts.outfit(
                  textStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              addHeight(10),
              provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : provider.tableNames.isEmpty
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
                                ...provider.tableNames.map((String table) {
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
              addHeight(20),
              GestureDetector(
                onTap: () {
                  String tableNameToUse = isCustomTable
                      ? customTableController.text
                      : selectedTable ?? "";

                  if (tableNameToUse.isNotEmpty) {
                    int? selectedTableId;
                    if (!isCustomTable) {
                      selectedTableId = provider.allTables
                          .firstWhere(
                              (table) => table.tableName == selectedTable)
                          .tableId;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MenuScreen(
                          orderIndex: widget.orderIndex,
                          tableName: tableNameToUse,
                          covers: int.parse(_controller.text),
                          ordeType: widget.orderType,
                          name: name.text,
                          tableID: selectedTableId?.toString() ?? "N/A",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select or enter a table")),
                    );
                  }
                },
                child: CustomButton(
                  width: MediaQuery.of(context).size.width * 0.45,
                  text: 'Create Order',
                  onPressed: () {},
                ),
              ),
              addHeight(15),
            ],
          ),
        );
      },
    );
  }
}
