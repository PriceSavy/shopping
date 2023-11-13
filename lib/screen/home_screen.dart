import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mobile/screen/liked_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';
import 'package:mobile/screen/compare_screen.dart';
import 'package:mobile/screen/category_screen.dart';
import '../models/itemInfo.dart';

String? email;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final ItemInfo items;
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<int> favoriteItemIds = [];
  bool initialLikedStatus = false;
  String barcodeScanResult = 'Search here...';
  bool show = true;
  bool cout = false;
  bool showSearchInput = false;
  GlobalKey<FormFieldState<String>> _textFieldKey =
      GlobalKey<FormFieldState<String>>();

  bool showDrawer = false;
  String apiUrl = 'items';
  bool isLoading = false;
  String image = 'assets/item.webp';
  String name = 'Butter Chicken Keto Bone Broth';
  String cate = 'Food';
  Icon icon = const Icon(Icons.favorite_border_outlined);
  FocusNode _searchFocusNode = FocusNode();

  void updateLikedStatus(int itemId, bool isLiked) {
    setState(() {
      if (isLiked) {
        favoriteItemIds.add(itemId);
      } else {
        favoriteItemIds.remove(itemId);
      }
    });
  }

  List data = [];

  int count = 0;
  bool fav = false;
  List filteredData = [];
  getCount() {
    if (filteredData.length == 0) {
      return count;
    } else
      return data.length;
  }

  @override
  void initState() {
    getData();

    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });  }

  Future getData() async {
    await Future.delayed(const Duration(seconds: 2));

    String myUrl = 'http://192.168.43.160:8000/api/items/';

    var response = await http.get(Uri.parse(myUrl));
    data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        showSearchInput = false;

        filteredData = data;

      });
    } else {
      log('data failed');
      throw Exception('Failed to load');
    }
  }

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
      print(e);
    }
  }

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

  getItems() {
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
          print(item['barcode']);
          return item['barcode']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<bool> itemFavorites = List.generate(filteredData.length, (_) => false);
    int selectedIndex = 0;

    void onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
        if (index == 0) {}
        if (index == 1) {
          // getMoney();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LikedItemsScreen(
                      favoriteItemIds: favoriteItemIds,
                      allItemsData: filteredData)));        }
        if (index == 2) {
          scanBarcode();
        }
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shadowColor: Colors.white12.withOpacity(0.8),
        width: 220,
        backgroundColor: Colors.white,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                child: Text(
              'Evermore Mwase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {},
            ),
            ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Exit'),
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.8),
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
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: true,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.indigo,
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
                              color: Colors.indigo.shade300,
                            ),
                          ),
                        ],
                        pinned: false,
                        expandedHeight: 10.0,
                        elevation: 2,
                        toolbarHeight: 35,
                        flexibleSpace: Container(
                            padding: const EdgeInsets.fromLTRB(315, 15, 0, 0),
                            child: PopupMenuItem(
                                child: IconButton(
                              icon: const Icon(
                                Icons.circle,
                                size: 10,
                              ),
                              onPressed: () {},
                              color: Colors.orange.shade300,
                            ))),
                      ),
                      SliverAppBar(
                        pinned: true,
                        toolbarHeight: 44,
                        primary: true,
                        floating: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.white,
                        excludeHeaderSemantics: true,
                        flexibleSpace: Container(
                          padding: const EdgeInsets.fromLTRB(0, 15, 0, 4),
                          // height: 42,
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white.withOpacity(0.2),
                                width: size.width,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          height: 42,
                                          width: 240,
                                          child: TextFormField(
                                            key: _textFieldKey,
                                            cursorColor: Colors.indigo,
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                  style: BorderStyle.solid,
                                                  width: 2,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                borderSide: const BorderSide(
                                                    style: BorderStyle.solid,
                                                    width: 30,
                                                    color: Colors.indigo),
                                              ),
                                              focusColor:
                                                  Colors.white.withOpacity(0.6),
                                              hintText: 'Search Item...',
                                              hintStyle: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w200,
                                              ),
                                              prefixIcon: const Icon(
                                                Icons.search_sharp,
                                                color: Colors.indigo,
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
                                            child: Container(
                                              width: 35,
                                              height: 30,
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/barcode.png'),
                                                fit: BoxFit.fill,
                                                color: Colors.indigo,
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
                      getItems()
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                List<bool> itemFavorites = List.generate(
                                    filteredData.length, (_) => false);

                                getCate() {
                                  if (filteredData[index]['categories'] == 1) {
                                    cate = 'Food and Beverage';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      2) {
                                    cate = 'Digital Services';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      3) {
                                    cate = 'Cosmetics and Body Care';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      4) {
                                    cate = 'Furniture and Decor';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      5) {
                                    cate = 'Electronics';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      6) {
                                    cate = 'Household';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      7) {
                                    cate = 'Toys and Hobbies';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      8) {
                                    cate = 'Pets';
                                  } else if (filteredData[index]
                                          ['categories'] ==
                                      9) {
                                    cate = 'Fashion';
                                  } else if (filteredData[index]
                                          ['categories'] ==
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
                                  sharedPreferences.setString('itemName',
                                      filteredData[index]['item_name']);
                                  sharedPreferences.setString(
                                      'itemCate', getCate());
                                  print(getCate());
                                  sharedPreferences.setString('itemImage',
                                      filteredData[index]['image_url']);
                                  sharedPreferences.setString('itemDesc',
                                      filteredData[index]['description']);
                                  sharedPreferences.setString(
                                      'itemDate',
                                      filteredData[index]
                                          ['created_at_timestamp']);
                                  sharedPreferences.setInt('barCode',
                                      filteredData[index]['barcode']);
                                  sharedPreferences.setString(
                                      'size', filteredData[index]['size']);

                                  sharedPreferences.setBool('isLiked', isLiked);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CompareItem(
                                                isLiked:
                                                    favoriteItemIds.contains(
                                                        filteredData[index]
                                                            ['id']),
                                                onLikedStatusChanged:
                                                    (newLikedStatus) {
                                                  setState(() {
                                                    initialLikedStatus =
                                                        newLikedStatus;
                                                  });
                                                },
                                                textFieldKey: _textFieldKey,
                                              )));
                                }

                                return Container(
                                    width: 400,
                                    height: 280,
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: Colors.white,
                                    )),
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () async {
                                        bool isLiked = favoriteItemIds.contains(
                                            filteredData[index]['id']);

                                        CompareScreen(isLiked);
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 2, 0, 0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      width: 200,
                                                      height: 35,
                                                      margin: const EdgeInsets.all(6),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.orange
                                                            .withOpacity(0.1),
                                                      ),
                                                      // color: Colors.black12.withOpacity(0.3),
                                                      child: TextButton(
                                                        onPressed: () {},
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.category,
                                                              size: 20,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                                '${getCate()}'),
                                                            const Spacer(),
                                                            const Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              size: 20,
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
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              padding: const EdgeInsets.fromLTRB(
                                                  0, 0, 70, 0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            0, 0, 70, 0),
                                                    child: Text(
                                                      filteredData[index]['item_name'].toString().trimLeft(),
                                                      textAlign: TextAlign.left,
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            0, 0, 55, 0),
                                                    child: Text(
                                                      'Click to Compare Prices',
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Colors.black
                                                            .withOpacity(0.9),
                                                        fontSize: 13,
                                                      ),
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
                                            Container(
                                              height: 35,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.share_outlined,
                                                        color: Colors
                                                            .indigo.shade300,
                                                      ),
                                                      hoverColor: Colors.amber,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => LikedItemsScreen(
                                                                    favoriteItemIds:
                                                                        favoriteItemIds,
                                                                    allItemsData:
                                                                        filteredData)));
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .outlined_flag_outlined,
                                                        color: Colors
                                                            .indigo.shade300,
                                                      ),
                                                      hoverColor: Colors.red,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                      icon: Icon(
                                                          favoriteItemIds.contains(
                                                                  filteredData[
                                                                          index]
                                                                      ['id'])
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border_outlined,
                                                          color: Colors
                                                              .indigo.shade300),
                                                      tooltip:
                                                          'Add to favorite',
                                                      onPressed: () {
                                                        if (favoriteItemIds
                                                            .contains(
                                                                filteredData[
                                                                        index]
                                                                    ['id'])) {
                                                          // Remove it from favorites
                                                          setState(() {
                                                            favoriteItemIds.remove(
                                                                filteredData[
                                                                        index]
                                                                    ['id']);
                                                          });
                                                        } else {
                                                          // Add it to favorites
                                                          setState(() {
                                                            favoriteItemIds.add(
                                                                filteredData[
                                                                        index]
                                                                    ['id']);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              childCount: filteredData.length,
                            ))
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  childCount: 1, (context, int index) {
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
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Colors.indigo.shade300,
              ),
              label: 'Favorite Items'),
          BottomNavigationBarItem(
              icon: Container(
                width: 30,
                height: 25,
                child: const Image(
                  image: AssetImage('assets/barcode.png'),
                  fit: BoxFit.fill,
                  color: Colors.indigo,
                ),
              ),
              label: 'Scanner'),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.orange,
        onTap: onItemTapped,
      ),
    );
  }
}
