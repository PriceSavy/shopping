import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';
import 'package:mobile/api/controllers.dart';
import 'package:mobile/screen/compare_screen.dart';
import 'package:mobile/services/barcode_scanner.dart';
import '../models/itemInfo.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final GlobalKey<_ControllersState> controllersKey = GlobalKey<_ControllersState>();

  // final GlobalKey<_ControllersState> _controllerKey = GlobalKey<_ControllersState>();
  late final ItemInfo items;

  String barcodeScanResult = 'Search here...'; // Store the scanned barcode data

  bool show = true;

  // late Future<List> ItemInfo items;
  bool showDrawer = false;
  String apiUrl = 'items';
  // final String myUrl = 'http://192.168.5.20/api/';
  String image = 'assets/item.webp';
  String name = 'Butter Chicken Keto Bone Broth';
  String cate = 'Food';
  // bool fav = true;
  FocusNode _searchFocusNode = FocusNode();
  favored() {
    setState(() {
      if (fav == true)
        fav = false;
      else
        fav = true;
    });
  }



  List data = [];

  int count = 0;
  bool fav = false;
  Color favoriteColor = Colors.black26;
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
  }

  Future getData() async {
    String myUrl = 'http://192.168.5.5:8000/api/items/';

    var response = await http.get(Uri.parse(myUrl));
    data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);

        filteredData = data;
        // print(data);
        // print('zikutheka aise');
        // print(data.toString());
      });
    } else {
      log('data failed');
      throw Exception('Failed to load');
    }
  }

  // bool show = true;

  // late Future<List> ItemInfo items;
  // bool showDrawer = false;
  // String apiUrl = 'items';
  // String image = 'assets/item.webp';
  // String name = 'Butter Chicken Keto Bone Broth';
  // String cate = 'Food';
  bool data_finished = false;
  TextEditingController favorite = TextEditingController();

  DataFinished() {
    if (data.last) {
      setState(() {
        data_finished = true;
      });
    }
  }
  Future<void> scanBarcode() async {
    try {
      final barcodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#FF0000', // Color for the scan button
        'Cancel', // Text for the cancel button
        false, // Flashlight
        ScanMode.BARCODE, // Specify the scan mode (QR_CODE, BARCODE, etc.)
      );

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        barcodeScanResult = barcodeResult;


        if(barcodeScanResult== "-1"){
          Fluttertoast.showToast(msg: "Item not found, or please scan properly",
              gravity: ToastGravity.CENTER,
              toastLength:Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red);
        }else{

          Fluttertoast.showToast(msg: "Item found",
            gravity: ToastGravity.CENTER,
            toastLength:Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
          backgroundColor: Colors.green);
          searchData(barcodeResult);
        }

      });

      // getData();
    } catch (e) {
      print(e);
    }
  }
  void filterData(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all data
      setState(() {
        filteredData = List.from(data);
      });
    } else {
      // Filter data based on the search query
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

  void searchData(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all data
      setState(() {
        filteredData = List.from(data);
      });
    } else {
      // Filter data based on the search query
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

  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        drawer: Drawer(
          shadowColor: Colors.white12.withOpacity(0.8),
          width: 220,
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Text(
                'Evermore Mwase',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
                onTap: () {},
              ),
              ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Exit'),
                  onTap: () {
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        body: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: true,
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
                      expandedHeight: 9.0,
                      elevation: 2,
                      toolbarHeight: 30,
                      flexibleSpace: Container(
                          padding: EdgeInsets.fromLTRB(315, 15, 0, 0),
                          child: PopupMenuItem(
                              child: IconButton(
                            icon: Icon(
                              Icons.circle,
                              size: 10,
                            ),
                            onPressed: () {},
                            color: Colors.orange.shade300,
                          ))),
                    ),
                    SliverAppBar(
                      pinned: true,
                      // collapsedHeight: 20,
                      toolbarHeight: 44,
                      // expandedHeight: 20,
                      primary: true,

                      floating: true,
                      automaticallyImplyLeading: false,

                      backgroundColor: Colors.white,
                      excludeHeaderSemantics: true,
                      // actions: [
                      //   IconButton(onPressed: (){}, icon: Icon(Icons.search))
                      // ],
                      flexibleSpace: Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 4),
                        // height: 42,
                        child: Column(
                          children: [
                            Container(
                              // height: 30,
                              // margin: EdgeInsets.fromLTRB(0, 12, 0, 0),

                              color: Colors.white.withOpacity(0.2),
                              width: size.width,

                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Container(
                                      //   margin:
                                      //       EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      //   height: 42,
                                      //   width: 280,
                                      //   child: SearchBar(
                                      //     leading: const Icon(
                                      //       Icons.search_sharp,
                                      //       color: Colors.black26,
                                      //     ),
                                      //     trailing: [
                                      //       Row(
                                      //         children: [
                                      //           TextButton(
                                      //             onPressed: () {},
                                      //             child:  Icon(
                                      //                 size: 32,
                                      //                 Icons.mic_none_outlined,
                                      //             color: Colors.indigo.shade300,),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ],
                                      //     textStyle: MaterialStateProperty.all(
                                      //         const TextStyle()),
                                      //     hintText: '${barcodeScanResult}',
                                      //     onChanged: (query) {
                                      //     final controllersWidget = context.findAncestorWidgetOfExactType<Controllers>();
                                      //     if (controllersWidget != null) {
                                      //     controllersWidget.filterData(query);
                                      //     }
                                      //     },
                                      //     hintStyle: MaterialStateProperty.all(
                                      //         const TextStyle(
                                      //       fontSize: 15,
                                      //       color: Colors.black26,
                                      //       fontWeight: FontWeight.bold,
                                      //           fontStyle: FontStyle.italic
                                      //     )),
                                      //   ),
                                      // ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        height: 42,
                                        width: 280,
                                        child: SearchBar(
                                          leading: const Icon(
                                            Icons.search_sharp,
                                            color: Colors.black26,
                                          ),
                                          trailing: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Icon(
                                                    size: 32,
                                                    Icons.mic_none_outlined,
                                                    color:
                                                        Colors.indigo.shade300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle()),
                                          hintText: 'Search item here...',
                                          focusNode: _searchFocusNode,
                                          onChanged: (query) {
                                            filterData(query);
                                          },
                                          hintStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black26,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          )),
                                        ),
                                      ),

                                      TextButton(
                                          onPressed: () {
                                            scanBarcode();
                                          },
                                          child: Icon(
                                            size: 32,
                                            Icons.barcode_reader,
                                            color: Colors.indigo.shade300,
                                          )),
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
                    SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 350.0,
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 25.0,
                          // mainAxisExtent: 400,
                          childAspectRatio: 1.3,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            getIcon() {
                              if (filteredData[index]['favorite'] == 1) {
                                favoriteColor = Colors.red;
                                return Icon(
                                  Icons.favorite_outlined,
                                );
                              } else if (filteredData[index]['favorite'] == 0) {
                                favoriteColor = Colors.indigo.shade300;

                                return Icon(
                                  Icons.favorite_outline,
                                );
                              }
                            }

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

                            CompareScreen() async {
                              final SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(
                                  'itemName', filteredData[index]['item_name']);
                              sharedPreferences.setString('itemCate', cate);
                              sharedPreferences.setString('itemImage',
                                  filteredData[index]['image_url']);
                              sharedPreferences.setString('itemDesc',
                                  filteredData[index]['description']);
                              sharedPreferences.setString('itemDate',
                                  filteredData[index]['created_at_timestamp']);
                              // sharedPreferences.setString('itemName', item['item_name']);
                            }

                            if (filteredData.isNotEmpty &&
                                index < filteredData.length) {
                              return Expanded(
                                child: Column(children: [
                                  Expanded(
                                    child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Colors.white,
                                        )),
                                        alignment: Alignment.center,
                                        // color: Colors.teal[100 * (index % 9)],
                                        child: InkWell(
                                          onTap: () async {
                                            CompareScreen();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CompareItem()));
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            //lIST OF ITEAMS
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 2, 0, 0),

                                                  // color: Colors.white.withOpacity(0.1),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                          width: 200,
                                                          height: 35,
                                                          margin:
                                                              EdgeInsets.all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: Colors.orange
                                                                .withOpacity(
                                                                    0.1),
                                                          ),
                                                          // color: Colors.black12.withOpacity(0.3),
                                                          child: TextButton(
                                                            onPressed: () {},
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .category,
                                                                  size: 20,
                                                                ),
                                                                Spacer(),
                                                                Text(
                                                                    '${getCate()}'),
                                                                Spacer(),
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye_outlined,
                                                                  size: 20,
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                      Spacer(),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 20, 0),
                                                        child: Text(
                                                          ' ${filteredData[index]['created_at_timestamp']}',
                                                          style: TextStyle(
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
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 70, 0),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 70, 0),
                                                        child: Text(
                                                          '${filteredData[index]['item_name'].toString().trimLeft()}',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 55, 0),
                                                        child: Text(
                                                          'Click to Compare Prices',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w200,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.9),
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 2, 0, 5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: Image.network(
                                                      '${filteredData[index]['image_url']}',
                                                      fit: BoxFit.fill,
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
                                                            Icons
                                                                .share_outlined,
                                                            color: Colors.indigo
                                                                .shade300,
                                                          ),
                                                          hoverColor:
                                                              Colors.amber,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: IconButton(
                                                          onPressed: () {},
                                                          icon: Icon(
                                                            Icons
                                                                .outlined_flag_outlined,
                                                            color: Colors.indigo
                                                                .shade300,
                                                          ),
                                                          hoverColor:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: IconButton(

                                                            // highlightColor: favoriteColor,
                                                            icon: Icon(
                                                              getIcon()?.icon,
                                                              color:
                                                                  favoriteColor,
                                                            ),
                                                            tooltip:
                                                                'Add to favorite',
                                                            onPressed: () {
                                                              if (filteredData[
                                                                          index]
                                                                      [
                                                                      'favorite'] ==
                                                                  1) {
                                                                setState(() {
                                                                  filteredData[
                                                                          index]
                                                                      [
                                                                      'favorite'] = 0;
                                                                });
                                                              } else if (filteredData[
                                                                          index]
                                                                      [
                                                                      'favorite'] ==
                                                                  0)
                                                                setState(() {
                                                                  filteredData[
                                                                          index]
                                                                      [
                                                                      'favorite'] = 1;
                                                                });
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ]),
                              );
                            } else {
                              return Container(
                              child: Center(
                                // child: Text('no data'),
                              ),
                              );
                            }
                          },
                          childCount: getCount(),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
