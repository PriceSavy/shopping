import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/screen/category.dart';
import 'package:mobile/screen/compare_screen.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LikedItemsScreen extends StatefulWidget {
  // final List<int> favoriteItemIds;

  LikedItemsScreen(
    // required this.favoriteItemIds,
  );

  @override
  State<LikedItemsScreen> createState() => _LikedItemsScreenState();
}

class _LikedItemsScreenState extends State<LikedItemsScreen> {
  List<Map<String, dynamic>>? likedItems = [];
  int selectedIndex = 1;
  List<int> favoriteItemIds = [];

  late List categories;
  bool initialLikedStatus = false;
  String barcodeScanResult = 'Search here...';
  bool show = true;
  bool cout = false;
  // late bool color;
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




  @override
  void initState() {

    // initialTheme();
    likedItem();

    super.initState();
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
      e;
    }
  }
  likedItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? filteredDataJson = prefs.getString('allData');

    List<String>? favoriteItemIdsString = prefs.getStringList('favoriteItemIds');
    List<int> favoriteItemId = favoriteItemIdsString?.map((id) => int.parse(id)).toList() ?? [];
    if (filteredDataJson != null) {
      List<dynamic> decodedData = json.decode(filteredDataJson);

      likedItems = decodedData.where((item) => favoriteItemId.contains(item['id'])).cast<Map<String, dynamic>>().toList();
     setState(() {

       // color = prefs.getBool('color')!;
       favoriteItemIds=favoriteItemId;
       likedItems = decodedData.where((item) => favoriteItemId.contains(item['id'])).cast<Map<String, dynamic>>().toList();

     });

    } else {

      setState(() {
        likedItems = []; // Set likedItems to an empty list if the stored JSON is null

      });
    }

    setState(() {
      // Use likedItems in your widget as needed.
    });


    // List<Map<String, dynamic>>? storedFilteredData =  json.decode(filteredDataJson!);

    // Assuming 'id' is the property you use to match liked items

    setState(() {
      // Use likedItems in your widget as needed.


    });
  }
  // initialTheme()async{
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  // return   color = prefs.getBool('color')!;
  //
  // }
  void searchData(String query) {
    if (query.isEmpty) {
      setState(() {
        likedItems= List.from(likedItems!);
      });
    } else {
      setState(() {
        likedItems = likedItems!.where((item) {
          return item['barcode']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));

      } else if (index == 1) {

      }else{
        scanBarcode();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Items',  style: Theme.of(context).textTheme.titleLarge),
        // backgroundColor:Colors.white,
        iconTheme: IconThemeData(

          size: 30,
        ),


      ),
      body: likedItems?.isEmpty ?? true
          ? const Center(
        child: Text('No liked items yet.'),
      )
          :CustomScrollView(
          slivers: <Widget>[

      SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              List<bool> itemFavorites = List.generate(
                  likedItems!.length, (_) => false);

              getCate() {
                if (likedItems![index]['categories'] == 1) {
                  cate = 'Food and Beverage';
                } else if (likedItems![index]
                ['categories'] ==
                    2) {
                  cate = 'Digital Services';
                } else if (likedItems![index]
                ['categories'] ==
                    3) {
                  cate = 'Cosmetics and Body Care';
                } else if (likedItems![index]
                ['categories'] ==
                    4) {
                  cate = 'Furniture and Decor';
                } else if (likedItems![index]
                ['categories'] ==
                    5) {
                  cate = 'Electronics';
                } else if (likedItems![index]
                ['categories'] ==
                    6) {
                  cate = 'Household';
                } else if (likedItems![index]
                ['categories'] ==
                    7) {
                  cate = 'Toys and Hobbies';
                } else if (likedItems![index]
                ['categories'] ==
                    8) {
                  cate = 'Pets';
                } else if (likedItems![index]
                ['categories'] ==
                    9) {
                  cate = 'Fashion';
                } else if (likedItems![index]
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
                    'item_id', likedItems![index]['id']);
                sharedPreferences.setString('itemName',
                    likedItems![index]['item_name']);
                sharedPreferences.setString(
                    'itemCate', getCate());
                print(getCate());
                sharedPreferences.setString('itemImage',
                    likedItems![index]['image_url']);
                sharedPreferences.setString('itemDesc',
                    likedItems![index]['description']);
                sharedPreferences.setString(
                    'itemDate',
                    likedItems![index]
                    ['created_at_timestamp']);
                sharedPreferences.setInt('barCode',
                    likedItems![index]['barcode']);
                sharedPreferences.setString(
                    'size', likedItems![index]['size']);

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
                  padding:
                  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide.none,
                        right: BorderSide.none,
                        left: BorderSide.none,
                        bottom: BorderSide(
                          color: Colors.white,
                        )

                    ),),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      bool isLiked = favoriteItemIds.contains(
                          likedItems![index]['id']);

                      CompareScreen(isLiked);
                    },
                    child: Container(
                      // color: Colors.white,
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
                                    margin:
                                    const EdgeInsets.all(
                                        6),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius
                                          .circular(15),
                                      color: Colors.orange
                                          .withOpacity(0.1),
                                    ),
                                    // color: Colors.black12.withOpacity(0.3),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Category()));


                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.category,
                                            size: 20,
                                            // color:Colors.orange.shade900,
                                          ),
                                          const Spacer(),


                                          Text(
                                            getCate().length <= 20
                                                ? getCate()
                                                : '${getCate().substring(0, 20)}...',
                                               style: Theme.of(context).textTheme.titleMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons
                                                .remove_red_eye_outlined,
                                            size: 20,
                                            // color:Colors.orange.shade900,

                                          )
                                        ],
                                      ),
                                    )),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets
                                      .fromLTRB(0, 0, 20, 0),
                                  child: Text(
                                    ' ${likedItems![index]['created_at_timestamp']}',
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
                                    likedItems![index]['item_name']
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
                              margin:
                              const EdgeInsets.fromLTRB(
                                  0, 2, 0, 5),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${likedItems![index]['image_url']}'),
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

                                    ),
                                    hoverColor: Colors.amber,
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => LikedItemsScreen(favoriteItemIds: likedItemsIds, allItemsData: likedItems!,
                                      //             )));
                                    },
                                    icon: Icon(
                                      Icons
                                          .outlined_flag_outlined,

                                    ),
                                    hoverColor: Colors.red,
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: favoriteItemIds.contains(
                                        likedItems![
                                        index]
                                        ['id'])?Icon(

                                      Icons
                                          .favorite,
                                      color: Colors.red,):Icon(

                                      Icons
                                          .favorite_border_outlined,
                                     ),
                                    tooltip:
                                    'Add to favorite',
                                    onPressed: () {
                                      int itemId = likedItems![index]['id'];
                                      if (favoriteItemIds.contains(itemId)) {
                                        // Remove it from favorites
                                        setState(() {
                                          favoriteItemIds.remove(itemId);
                                        });
                                      } else {
                                        // Add it to favorites
                                        setState(() {
                                          favoriteItemIds.add(itemId);
                                        });
                                      }

                                      // Save the updated list of liked item IDs
                                      saveFavoriteItemIds(favoriteItemIds);
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
            childCount: likedItems!.length,
          ))]),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black26
                  : Colors.white54,

            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favorite Items',
          ),
          BottomNavigationBarItem(
            icon: Container(
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
            label: 'Scanner',
          ),
        ],
        currentIndex: selectedIndex,
        fixedColor:  Colors.orange.shade900,
        onTap: onItemTapped,
      ),
    );
  }

  Future<void> saveFavoriteItemIds(List<int> favoriteItemIds) async {
    // print(favoriteItemIds);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteItemIds', favoriteItemIds.map((id) => id.toString()).toList());
  }


}
