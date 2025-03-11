import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:order_tracking/core/constants/constant_colors.dart';
import 'package:order_tracking/core/helper/custom_toast.dart';
import 'package:order_tracking/core/helper/sized_box_extension.dart';

import 'package:order_tracking/presentation/dialogs/choose_menu_type_parcel.dart';
import 'package:order_tracking/presentation/provider/get_categories_provider.dart';
import 'package:order_tracking/presentation/provider/menu_provider.dart';
import 'package:order_tracking/presentation/provider/theme_changer_provider.dart';
import 'package:order_tracking/presentation/screens/home/cart_screen_without_charges.dart';
import 'package:order_tracking/presentation/screens/home/home_screen.dart';
import 'package:order_tracking/presentation/screens/home/parcel_cart.dart';
import 'package:order_tracking/presentation/widgets/custom_button_with_icon.dart';
import 'package:order_tracking/presentation/widgets/custom_text_feild.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MenuScreenParcel extends StatefulWidget {
  String? name;
  String? mobileNo;
  String? address;

  String? ordeType;
  String? orderIndex;

  MenuScreenParcel(
      {super.key,
      this.name,
      this.orderIndex,
      this.address,
      this.mobileNo,
      this.ordeType});

  @override
  State<MenuScreenParcel> createState() => _MenuScreenParcelState();
}

class _MenuScreenParcelState extends State<MenuScreenParcel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isTabControllerReady = false;
  List images = [
    {'image': "assets/images/menu.jpg"},
    {'image': "assets/images/salad.jpg"},
    {'image': "assets/images/bbq.jpg"},
    {'image': "assets/images/turkish.jpg"},
    {'image': "assets/images/chapal.jpeg"},
    {'image': "assets/images/khada.webp"},
    {'image': "assets/images/karahi.jpg"},
    {'image': "assets/images/rosh.jpg"},
    {'image': "assets/images/pulao.jpg"},
    {'image': "assets/images/roti.webp"},
    {'image': "assets/images/drinks.jpg"},
    {'image': "assets/images/rus.webp"},
    {'image': "assets/images/raw.webp"},
  ];
  @override
  void initState() {
    super.initState();

    print(widget.mobileNo);

    print(widget.address);

    Future.microtask(() {
      var provider = Provider.of<GetCategoriesProvider>(context, listen: false);
      provider.getCategory().then((_) {
        if (mounted && provider.categoryName.isNotEmpty) {
          // Ensure categories are not empty
          setState(() {
            _tabController = TabController(
              length: provider.categoryName.length + 1, // +1 for 'All Menu'
              vsync: this,
            );
            _isTabControllerReady = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    if (_isTabControllerReady) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.orderIndex == '0'
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ParcelCart(
                          orderType: widget.ordeType,
                          orderIndex: widget.orderIndex,
                        ),
                      ))
                    : Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CartScreenWithoutCharges(
                          orderType: widget.ordeType,
                          orderIndex: widget.orderIndex,
                        ),
                      ));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
          title: const Text("Menus"),
          centerTitle: true,
          flexibleSpace: Container(),
          bottom: PreferredSize(
            preferredSize:
                const Size.fromHeight(80), // Increased height for images
            child: _isTabControllerReady
                ? Consumer<GetCategoriesProvider>(
                    builder: (BuildContext context, provider, child) {
                      List<String> categories = [
                        'All Menu',
                        ...provider.categoryName
                      ];

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            int index = categories.indexOf(category);
                            bool isSelected = _tabController.index == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tabController.animateTo(index);
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ConstantsColors.primary
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (index <
                                        images
                                            .length) // Check to avoid index out of range
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              20), // Ensure rounded corners
                                          color: Colors.grey[
                                              300], // Optional background color
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              20), // Match container's border
                                          child: Image.asset(
                                            images[index][
                                                'image'], // Use the static image
                                            fit: BoxFit
                                                .fill, // Ensure the image covers the entire container
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 3),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  )
                : const SizedBox(height: 50),
          ),
        ),
      ),
      body: _isTabControllerReady
          ? Consumer<GetCategoriesProvider>(
              builder: (BuildContext context, provider, child) {
                List<String> categories = [
                  'All Menu',
                  ...provider.categoryName
                ];
                return TabBarView(
                  controller: _tabController,
                  children: categories
                      .map((category) => MenuListParcel(
                            category: category,
                            name: widget.name,
                            mobileNo: widget.mobileNo,
                            address: widget.address,
                            ordeType: widget.ordeType,
                          ))
                      .toList(),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// ignore: must_be_immutable
class MenuListParcel extends StatefulWidget {
  final String category;
  String? name;
  String? ordeType;
  String? mobileNo;
  String? address;
  MenuListParcel({
    super.key,
    required this.category,
    this.address,
    this.mobileNo,
    this.ordeType,
    this.name,
  });

  @override
  State<MenuListParcel> createState() => _MenuListParcelState();
}

class _MenuListParcelState extends State<MenuListParcel>
    with SingleTickerProviderStateMixin {
  Map<String, int> itemCounts = {};
  Map<String, String> buttonStates = {};
  TextEditingController searchC = TextEditingController();
  String searchQuery = "";

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    print("Order type is:${widget.address}");
    print("Order type is:${widget.mobileNo}");

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<MenuProvider>(context, listen: false).getMenu();
      } catch (e) {
        print("Error fetching menu: $e");
      }
    });

    searchC.addListener(() {
      setState(() {
        searchQuery = searchC.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void increment(String item) {
    setState(() {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
      buttonStates[item] = "increment";
    });
  }

  void decrement(String item) {
    setState(() {
      if (itemCounts[item]! > 0) {
        itemCounts[item] = itemCounts[item]! - 1;
        buttonStates[item] = "decrement";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Consumer2<MenuProvider, GetCategoriesProvider>(
        builder: (BuildContext context, menuProvider, categoryProvider, child) {
          int? selectedCategoryId;
          int categoryIndex =
              categoryProvider.categoryName.indexOf(widget.category);

          if (categoryIndex != -1 &&
              categoryIndex < categoryProvider.catId.length) {
            selectedCategoryId = categoryProvider.catId[categoryIndex];
          }

          var filteredMenus = widget.category == "All Menu"
              ? menuProvider.menuList
              : menuProvider.menuList
                  .where((menu) => menu.cid == selectedCategoryId)
                  .toList();

          var searchedMenus = filteredMenus.where((menu) {
            return menu.name!.toLowerCase().contains(searchQuery);
          }).toList();

          return Column(
            children: [
              addHeight(25),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextField(
                  controller: searchC,
                  hintText: 'Search food',
                  iconPath: 'assets/images/search.svg',
                  iconcolor: Colors.grey,
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: searchedMenus.length,
                    itemBuilder: (context, index) {
                      String menuItem = searchedMenus[index].name ?? '';
                      String menuId = searchedMenus[index].menuId.toString();

                      return Column(
                        children: [
                          AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 600),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    bool isTablet = constraints.maxWidth > 600;

                                    return Consumer<ThemeChangerProvider>(
                                      builder: (context, themeProvider, child) {
                                        final bool isDarkMode =
                                            themeProvider.themeMode ==
                                                ThemeMode.dark;

                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? const Color(0xff3C3D37)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    isDarkMode ? 0.2 : 0.4),
                                                blurRadius: 5,
                                              ),
                                            ],
                                          ),
                                          child: isTablet
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          menuItem,
                                                          style: TextStyle(
                                                            fontSize: 23,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                        addHeight(5),
                                                        Text(
                                                          "Rs. ${searchedMenus[index].rate.toString()}",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: isDarkMode
                                                                ? Colors
                                                                    .grey[400]
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 26.0),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isDarkMode
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : ConstantsColors
                                                                      .bdColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      decrement(
                                                                          menuItem),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      size: 22,
                                                                      Icons
                                                                          .remove,
                                                                      color: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 25),
                                                                Text(
                                                                  (itemCounts[menuItem] ??
                                                                          0)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 25),
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      increment(
                                                                          menuItem),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      size: 22,
                                                                      Icons.add,
                                                                      color: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 16),
                                                        GestureDetector(
                                                          onTap: () {
                                                            itemCounts[menuItem] ==
                                                                        null ||
                                                                    itemCounts[
                                                                            menuItem] ==
                                                                        0
                                                                ? CustomToast
                                                                    .showToast(
                                                                        message:
                                                                            'Please Select Quantity')
                                                                : showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return ChooseMenuTypeParcel(
                                                                        address:
                                                                            widget.address,
                                                                        mobileNo:
                                                                            widget.mobileNo,
                                                                        menuId:
                                                                            menuId,
                                                                        orderType:
                                                                            widget.ordeType,
                                                                        cusName:
                                                                            widget.name,
                                                                        rate: searchedMenus[index]
                                                                            .rate,
                                                                        prodName:
                                                                            menuItem,
                                                                        quntity:
                                                                            itemCounts[menuItem].toString(),
                                                                      );
                                                                    },
                                                                  ).then((_) {
                                                                  // Reset the quantity after dialog is closed
                                                                  setState(() {
                                                                    itemCounts[
                                                                        menuItem] = 0;
                                                                  });
                                                                });
                                                          },
                                                          child:
                                                              CustomButtonWithIcon(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.09,
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.06,
                                                            icon: Icons
                                                                .shopping_cart_outlined,
                                                            iconSize: 35,
                                                            onPressed: () {},
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        menuItem,
                                                        style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        "Rs. ${searchedMenus[index].rate.toString()}",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color: isDarkMode
                                                              ? Colors.grey[400]
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: isDarkMode
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : ConstantsColors
                                                                      .bdColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      decrement(
                                                                          menuItem),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      size: 22,
                                                                      Icons
                                                                          .remove,
                                                                      color: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 25),
                                                                Text(
                                                                  (itemCounts[menuItem] ??
                                                                          0)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 25),
                                                                GestureDetector(
                                                                  onTap: () =>
                                                                      increment(
                                                                          menuItem),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      size: 22,
                                                                      Icons.add,
                                                                      color: isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: () {
                                                              itemCounts[menuItem] ==
                                                                          null ||
                                                                      itemCounts[
                                                                              menuItem] ==
                                                                          0
                                                                  ? CustomToast
                                                                      .showToast(
                                                                          message:
                                                                              'Please Select Quantity')
                                                                  : showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return ChooseMenuTypeParcel(
                                                                          address:
                                                                              widget.address,
                                                                          mobileNo:
                                                                              widget.mobileNo,
                                                                          menuId:
                                                                              menuId,
                                                                          orderType:
                                                                              widget.ordeType,
                                                                          cusName:
                                                                              widget.name,
                                                                          rate:
                                                                              searchedMenus[index].rate,
                                                                          prodName:
                                                                              menuItem,
                                                                          quntity:
                                                                              itemCounts[menuItem].toString(),
                                                                        );
                                                                      },
                                                                    );
                                                            },
                                                            child:
                                                                CustomButtonWithIcon(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.15,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.06,
                                                              icon: Icons
                                                                  .shopping_cart_outlined,
                                                              onPressed: () {},
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
