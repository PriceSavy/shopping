import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile/screen/category.dart';
import 'package:mobile/screen/liked_items.dart';
import 'package:mobile/services/ThemeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:mobile/screen/compare_screen.dart';

List<String>? pickedItems;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getFavoriteItemIds();
    // initialTheme();
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  int selectedIndex = 0;

  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();

  List<int> favoriteItemIds = [];
  List data = [];
  List filteredData = [];
  late List categories;

  bool cout = false;
  // bool color = false;
  bool showSearchInput = false;
  bool initialLikedStatus = false;
  bool isLoading = false;

  String barcodeScanResult = 'Search here...';
  String cate = '';
  final FocusNode _searchFocusNode = FocusNode();

//Get all the items from database
  Future<void> getData() async {
    try {
      List<int> categoryIds = await getCate();
      // await getFavoriteItemIds();

      // await Future.delayed(const Duration(seconds: 2));

      String myUrl = 'http://192.168.43.160:8000/api/items/';

      var response = await http.get(Uri.parse(myUrl));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          showSearchInput = false;

          filteredData = data.where((item) {
            int itemCategory = item['categories'];

            // Check if the item's category is in the specified categories list
            return categoryIds.contains(itemCategory);
          }).toList();
        });

        // likedItems();
      } else {
        log('data failed');
        throw Exception('Failed to load');
      }
    } catch (e) {
      // Handle errors
    }
  }

//sort the data depending on the categories
  Future<List<int>> getCate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selectedCategoryIdsString =
        prefs.getStringList('selectedCategories');

    setState(() {
      pickedItems = selectedCategoryIdsString;
    });

    List<int> categoryIds = pickedItems
            ?.map((String? id) => int.tryParse(id ?? '') ?? 0)
            .toList() ??
        [];

    return categoryIds;
  }
// This is for searching data

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = List.from(data);
      });
    } else {
      setState(() {
        filteredData = data.where((item) {
          return item['item_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }
//change the color of the backgroud

  // Future changeColor() async {
  //   if (color == false) {
  //     color = true;
  //   } else {
  //     color = false;
  //   }
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('color', color);
  //
  //   return color;
  // }

//to scan the barcode
  Future<void> scanBarcode() async {
    try {
      final barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000',
        'Cancel',
        false, // Flashlight
        ScanMode.BARCODE,
      );
      showSearchInput = false;

      if (!mounted) return;
      setState(() {
        barcodeScanResult = barcodeResult;

        if (barcodeScanResult == "-1") {
          Fluttertoast.showToast(
              msg: "Item not found, re-scan",
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red);
        } else {
          Fluttertoast.showToast(
              msg: "Item found",
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green);
          searchData(barcodeResult);
        }
      });
    } catch (e) {
      e;
    }
  }

//whether to display the items or not
  bool getItems() {
    if (filteredData.isEmpty) {
      setState(() {
        cout = false;
      });
    } else {
      setState(() {
        cout = true;
      });
    }
    return cout;
  }

  void searchData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = List.from(data);
      });
    } else {
      setState(() {
        filteredData = data.where((item) {
          return item['barcode']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

//runs initially to show if the data is liked or not
  Future<List<int>> getFavoriteItemIds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteItemIdsString =
        prefs.getStringList('favoriteItemIds');
    setState(() {
      favoriteItemIds =
          favoriteItemIdsString?.map((id) => int.parse(id)).toList() ?? [];
    });

    getData();
    return favoriteItemIds;
  }

  //runs initially to get the color of the app
  // Future<bool> initialTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   setState(() {
  //     // color = prefs.getBool('color')!;
  //   });
  //
  //   // return color;
  // }

//sent the items to the sharedpreference
  void toLiked() async {
    String filteredDataJson = json.encode(filteredData);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('allData', filteredDataJson);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
      if (index == 1) {
        toLiked();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LikedItemsScreen()));
      }
      if (index == 2) {
        scanBarcode();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shadowColor: Colors.white12.withOpacity(0.8),
        width: 220,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Column(
                  children: [
                    // Text('MP',style: TextStyle(
                    //   fontSize: 30,
                    //   fontWeight: FontWeight.bold,
                    //
                    // ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),

                    Row(
                      children: [
                        Text('M',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,

                        ),),
                        Text('te',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,


                        ),),
                        Text('N',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,

                        ),),
                        Text('go',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,


                        ),),
                        Text('A',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,

                        ),),

                        Text('pp',style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,


                        ),),
                      ],
                    )

                  ],
                )),
            ListTile(
              leading:  Icon(Icons.light_mode_outlined,
                ),
              title:  Text('Change Theme',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                // changeColor();
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
            ),
            ListTile(
              leading:  Icon(Icons.category,
                ),
              title:  Text('Categories',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Category()));

              },
            ),
            ListTile(
              leading:  Icon(Icons.help,
                ),
              title:  Text('Help',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {


              },
            ),
            ListTile(
                leading: Icon(Icons.close,
                  ),
                title:  Text('Exit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      body: RefreshIndicator(
          onRefresh: getData,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: size.height,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        // backgroundColor: Colors.white,
                        automaticallyImplyLeading: true,
                        leading: IconButton(
                          icon: Icon(
                            Icons.menu,
                            // color:  Colors.orange.shade900,
                            size: 32.0,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications_none,
                              size: 25,
                              // color:
                              //      Colors.orange.shade900,
                            ),
                          ),
                        ],
                        pinned: false,
                        expandedHeight: 10.0,
                        elevation: 2,
                        toolbarHeight: 35,
                        flexibleSpace: Container(
                            padding: const EdgeInsets.fromLTRB(315, 12, 0, 0),
                            child: PopupMenuItem(
                                child: IconButton(
                              icon: const Icon(
                                Icons.circle,
                                size: 10,
                                color: Colors.lightGreenAccent,
                              ),
                              onPressed: () {},
                              color: Colors.green.shade900,
                            ))),
                      ),
                      SliverAppBar(
                        pinned: true,
                        toolbarHeight: 44,
                        primary: true,
                        floating: true,
                        automaticallyImplyLeading: false,

                        excludeHeaderSemantics: true,
                        flexibleSpace: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 4),
                          // height: 42,
                          child: Column(
                            children: [
                              Container(
                                // color: Colors.white.withOpacity(0.2),
                                width: size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          height: 42,
                                          width: 240,
                                          child: TextFormField(
                                            key: _textFieldKey,
                                            cursorColor: Colors.black,
                                            controller: searchController,
                                            decoration: InputDecoration(

                                              focusColor: Colors.white.withOpacity(0.6),
                                              hintText: 'Search Item...',
                                              hintStyle: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w200,
                                              ),
                                              prefixIcon: Icon(
                                                Icons.search_sharp,
                                              ),
                                            ),
                                            focusNode: _searchFocusNode,
                                            onChanged: (query) {
                                              filterData(query);
                                            },
                                            onTap: () {
                                              // showTick3();

                                              if (searchController
                                                  .text.isEmpty) {
                                                // tick3 = true;
                                                _searchFocusNode.requestFocus();
                                              }
                                            },
                                          ),
                                        ),
                                        const Spacer(),
                                        TextButton(
                                            onPressed: () {
                                              scanBarcode();
                                            },
                                            child: SizedBox(
                                              width: 35,
                                              height: 30,
                                              child: Image(
                                                image:  AssetImage(
                                                    'assets/barcode.png'),
                                                fit: BoxFit.fill,
                                                color: Theme.of(context).brightness == Brightness.light
                                                    ? Colors.orange.shade900
                                                    : Colors.white,
                                              ),
                                            )),
                                        const Spacer()
                                      ],
                                    ),
                                  ],
                                ),
                              )

                              //other details
                            ],
                          ),
                        ),
                      ),
                      if (getItems())
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            getCate() {
                              if (filteredData[index]['categories'] == 1) {
                                cate = 'Food and Beverage';
                              } else if (filteredData[index]['categories'] ==
                                  2) {
                                cate = 'Digital Services';
                              } else if (filteredData[index]['categories'] ==
                                  3) {
                                cate = 'Cosmetics and Body Care';
                              } else if (filteredData[index]['categories'] ==
                                  4) {
                                cate = 'Furniture and Decor';
                              } else if (filteredData[index]['categories'] ==
                                  5) {
                                cate = 'Electronics';
                              } else if (filteredData[index]['categories'] ==
                                  6) {
                                cate = 'Household';
                              } else if (filteredData[index]['categories'] ==
                                  7) {
                                cate = 'Toys and Hobbies';
                              } else if (filteredData[index]['categories'] ==
                                  8) {
                                cate = 'Pets';
                              } else if (filteredData[index]['categories'] ==
                                  9) {
                                cate = 'Fashion';
                              } else if (filteredData[index]['categories'] ==
                                  10) {
                                cate = 'Others';
                              }
                              return cate;
                            }

                            CompareScreen(bool isLiked) async {
                              final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setInt(
                                  'item_id', filteredData[index]['id']);
                              sharedPreferences.setString(
                                  'itemName', filteredData[index]['item_name']);
                              sharedPreferences.setString(
                                  'itemCate', getCate());
                              sharedPreferences.setString('itemImage',
                                  filteredData[index]['image_url']);
                              sharedPreferences.setString('itemDesc',
                                  filteredData[index]['description']);
                              sharedPreferences.setString('itemDate',
                                  filteredData[index]['created_at_timestamp']);
                              sharedPreferences.setInt(
                                  'barCode', filteredData[index]['barcode']);
                              sharedPreferences.setString(
                                  'size', filteredData[index]['size']);

                              sharedPreferences.setBool('isLiked', isLiked);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompareItem(
                                            textFieldKey: _textFieldKey,
                                          )));
                            }

                            return Container(
                                width: 400,
                                height: 280,
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide.none,
                                      right: BorderSide.none,
                                      left: BorderSide.none,
                                      bottom: BorderSide(
                                        color: Colors.white,
                                      )

                                    ),


                                ),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () async {
                                    bool isLiked = favoriteItemIds
                                        .contains(filteredData[index]['id']);

                                    CompareScreen(isLiked);
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 2, 0, 0),
                                        child: Row(
                                          children: [
                                            Container(
                                                width: 240,
                                                height: 35,
                                                margin: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.orange
                                                      .withOpacity(0.1),
                                                ),
                                                // color: Colors.black12.withOpacity(0.3),
                                                child: TextButton(
                                                  onPressed: () {

                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const Category()));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.category,
                                                        size: 20,
                                                        // color:  Colors.orange
                                                        //         .shade900,
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        getCate().length <= 20
                                                            ? getCate()
                                                            : '${getCate().substring(0, 17)}...',
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons
                                                            .remove_red_eye_outlined,
                                                        size: 20,
                                                        // color: Colors.orange
                                                        //         .shade900,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            const Spacer(),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 0, 20, 0),
                                              child: Text(
                                                ' ${filteredData[index]['created_at_timestamp']}',
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: size.width,
                                       alignment: Alignment.topLeft,
                                        child: Column(
                                          children: [
                                            Container(
                                              // margin: const EdgeInsets.fromLTRB(
                                              //     10, 0, 0, 0),
                                              // padding:
                                              //     const EdgeInsets.fromLTRB(
                                              //         0, 0, 70, 0),

                                              alignment: Alignment.topLeft,
                                             margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                             child: Text(
                                                  filteredData[index]['item_name']
                                                      .toString()
                                                      .trimLeft(),
                                                  textAlign: TextAlign.left,
                                               style: Theme.of(context).textTheme.titleLarge,

                                                ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                              // padding:
                                              //     const EdgeInsets.fromLTRB(
                                              //         0, 0, 55, 0),
                                              child: Text(
                                                'Click to Compare Prices',
                                                textAlign: TextAlign.left,
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 150,
                                          height: 50,
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 2, 0, 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  '${filteredData[index]['image_url']}'),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 35,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.share_outlined,
                                                  // color: Colors.orange.shade900
                                                  //         .withOpacity(0.5),
                                                ),
                                                hoverColor: Colors.amber,
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.outlined_flag_outlined,
                                                  // color: Colors.orange.shade900
                                                  //         .withOpacity(0.5),
                                                ),
                                                hoverColor: Colors.red,
                                              ),
                                            ),
                                            Expanded(
                                              child: IconButton(
                                                icon: favoriteItemIds.contains(
                                                        filteredData[index]
                                                            ['id'])
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      )
                                                    : Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        // color: Colors
                                                        //         .orange.shade900
                                                        //         .withOpacity(
                                                        //             0.5),
                                                      ),
                                                tooltip: 'Add to favorite',
                                                onPressed: () {
                                                  int itemId =
                                                      filteredData[index]['id'];
                                                  if (favoriteItemIds
                                                      .contains(itemId)) {
                                                    // Remove it from favorites
                                                    setState(() {
                                                      favoriteItemIds
                                                          .remove(itemId);
                                                    });
                                                  } else {
                                                    // Add it to favorites
                                                    setState(() {
                                                      favoriteItemIds
                                                          .add(itemId);
                                                    });
                                                  }

                                                  saveFavoriteItemIds(
                                                      favoriteItemIds);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          childCount: filteredData.length,
                        ))
                      else
                        SliverList(
                            delegate: SliverChildBuilderDelegate(childCount: 1,
                                (context, int index) {
                          return Column(
                            children: [
                              isLoading
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: const Text("can't load Items"),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    )
                            ],
                          );
                        })),
                    ],
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white54,
              ),
              label: 'Favorite Items'),
          BottomNavigationBarItem(
              icon: SizedBox(
                width: 30,
                height: 25,
                child: Image(
                  image: AssetImage('assets/barcode.png'),
                  fit: BoxFit.fill,
                   color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black26
                    : Colors.white54,
                ),
              ),
              label: 'Scanner'),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.orange.shade900,
        onTap: onItemTapped,
      ),
    );
  }

  Future<void> saveFavoriteItemIds(List<int> favoriteItemIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'favoriteItemIds', favoriteItemIds.map((id) => id.toString()).toList());
  }


}
