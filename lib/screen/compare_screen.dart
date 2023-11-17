import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

int? item_id;
String? item_name;
String? item_category;
String? item_image;
String? description;
String? item_date;
int? barcode;
String? sizeItem;

class CompareItem extends StatefulWidget {
  // final bool isLiked;
  // final Function(bool) onLikedStatusChanged;
  final GlobalKey<FormFieldState<String>> textFieldKey;

  CompareItem({
    // required this.isLiked,
    // required this.onLikedStatusChanged,
    required this.textFieldKey,
  });

  @override
  State<CompareItem> createState() =>
      _CompareItemState(textFieldKey: textFieldKey);
}

class _CompareItemState extends State<CompareItem> {
  _CompareItemState({required this.textFieldKey});
  @override
  void initState() {
    getItemData();
    // initialTheme();
    likedItem();
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  int selectedIndex = 1;
  List<int> favoriteItemIds = [];
  List<Map<String, dynamic>>? likedItems = [];


  // bool color=false;
  // bool isLiked;
  bool isLoading = false;
  bool showContainer = true;
  bool showContainer1 = false;
  bool showContainer2 = false;
  bool showContainer3 = false;
  bool showSearchInput = false;
  bool content = true;
  bool count = true;
  bool tick = true;
  bool tick2 = false;
  bool tick3 = false;
  List data = [];
  List<int> favoriteShopId = [];
  List<dynamic> filteredShops = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState<String>> textFieldKey;
  final Uri _url = Uri.parse('https://flutter.dev');

  bool getCount() {
    if (filteredShops.isEmpty) {
      setState(() {
        count = false;
      });
    } else {
      setState(() {
        count = true;
      });
    }
    return count;
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



  void showScreen() {
    setState(() {
      showContainer = showContainer1;
      showContainer = true;
      showContainer2 = false;
      showContainer3 = false;
      showSearchInput = false;
      showTick();
    });
  }

  void showScreen2() {
    setState(() {
      showContainer = false;
      showContainer3 = false;
      showContainer2 = true;
      showSearchInput = false;
      showTick2();
    });
  }

  void showScreen3() {
    setState(() {
      showContainer = false;
      showContainer2 = false;
      showContainer3 = true;
      tick = false;
      tick2 = false;
      showTick3();
    });
  }

  void showTick() {
    setState(() {
      tick = true;
      tick2 = false;
      tick3 = false;
      showSearchInput = false;
    });
  }

  void showTick2() {
    setState(() {
      tick = false;
      tick2 = true;
      tick3 = false;
      showSearchInput = false;
    });
  }

  void showTick3() {
    setState(() {
      tick = false;
      tick2 = false;
      tick3 = true;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).pop();
      }
      if (index == 1) {}
      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  void filterShops(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show all shops
        filteredShops = data;
      } else {
        // Filter shops based on the search query
        filteredShops = data.where((shop) {
          return shop['shop']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  // Future<bool> initialTheme() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return color = prefs.getBool('color')!;
  // }

  Future getItemData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var itemId = sharedPreferences.getInt('item_id');
    var itemName = sharedPreferences.getString('itemName');
    var barCode = sharedPreferences.getInt('barCode');
    var size_item = sharedPreferences.getString('size');
    var itemCate = sharedPreferences.getString('itemCate');
    var itemImage = sharedPreferences.getString('itemImage');
    var itemDesc = sharedPreferences.getString('itemDesc');
    var itemDate = sharedPreferences.getString('itemDate');

    setState(() {
      item_id = itemId;
      item_name = itemName!;
      item_category = itemCate;
      item_image = itemImage;
      description = itemDesc;
      item_date = itemDate;
      barcode = barCode;
      sizeItem = size_item;
      getCount();
      getPrices();
    });
  }

  Future getPrices() async {
    await Future.delayed(const Duration(seconds: 2));
    print(item_id);

    String myUrl = 'http://192.168.43.160:8000/api/prices/get/$item_id';
    final TextEditingController searchController = TextEditingController();

    var response = await http.get(Uri.parse(myUrl));
    data = jsonDecode(response.body);
    showTick();
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
        filteredShops = data;
        showSearchInput = false;
        content = true;
        print(data);
      });
    }
  }
  Divider _divider() {
    return Divider(
      color: Colors.orange.withOpacity(0.2),
      thickness: 3,
      indent: 5,
      endIndent: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: getItemData,
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: content ? 300.0 : 150,
                      collapsedHeight: content ? 325.0 : 80,
                      automaticallyImplyLeading: true,
                      floating: false,
                      // backgroundColor:
                      //      Colors.white,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          // color: Colors.orange.shade900,
                          // size: 30,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                      ),
                      actions: [
                        Container(
                          width: 270,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.orange.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),

                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Container(

                            margin: const EdgeInsets.fromLTRB(2, 0, 0, 0),




                            child:TextButton(
                              onPressed: () {},
                              child: Row(
                                children: [


                                   SizedBox(
                                     width: 20,
                                   ),
                                  // const Spacer(),
                                  Text(
                                    item_name.toString(),
                                      style: Theme.of(context).textTheme.titleLarge
                                  ),
                                  const Spacer(),


                                ],
                              ),
                            ),
                          ),


                        ),
                        IconButton(
                          icon: favoriteItemIds.contains(item_id as int)?Icon(

                            Icons
                                .favorite,
                            color: Colors.red,
                          ):Icon(

                            Icons
                                .favorite_border_outlined,
                            // color: Colors.orange.shade900.withOpacity(0.5),

                          ),
                          tooltip:
                          'Add to favorite',
                          onPressed: () {
                            // int itemId = likedItems[item_id];
                            if (favoriteItemIds.contains(item_id as int)) {
                              // Remove it from favorites
                              setState(() {
                                favoriteItemIds.remove(item_id as int);
                              });
                            } else {
                              // Add it to favorites
                              setState(() {
                                favoriteItemIds.add(item_id as int);
                              });
                            }

                            // Save the updated list of liked item IDs
                            saveFavoriteItemIds(favoriteItemIds);
                          },
                        )
                      ],


                      flexibleSpace: Container(
                        height: 300,
                        margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                        child: Container(
                          height: 300,
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Column(
                            children: [
                              content
                                  ? SizedBox(
                                      height: 200,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 140,
                                            height: 200,
                                            margin: const EdgeInsets.fromLTRB(
                                                5, 0, 0, 2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: DecorationImage(
                                                image:
                                                    NetworkImage('$item_image'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade300
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(8, 2, 1, 0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  '$sizeItem',
                                                                  style:
                                                                  Theme.of(context).textTheme.titleMedium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 1,
                                                              ),
                                                              const Icon(
                                                                Icons
                                                                    .qr_code_2_outlined,
                                                                size: 15,
                                                              ),
                                                              Text(
                                                                '$barcode',
                                                                style: Theme.of(context).textTheme.bodyLarge,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                              ),
                                                            ],
                                                          ),
                                                          _divider(),
                                                        ],
                                                      )),
                                                  Row(
                                                    children: [
                                                      Container(
                                                          // height: 110,
                                                          margin:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  5, 2, 0, 0),
                                                          decoration:
                                                              BoxDecoration(
                                                            // color: Colors.white
                                                            //     .withOpacity(0.1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                description
                                                                    .toString(),
                                                                style:
                                                                Theme.of(context).textTheme.bodyLarge,
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextButton(
                                    onPressed: showScreen,
                                    child: Row(
                                      children: [
                                        content
                                            ? Text(
                                                'Available Shops',
                                                style:  Theme.of(context).textTheme.titleMedium,
                                              )
                                            : TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    content = true;
                                                    showSearchInput = false;
                                                  });
                                                },
                                                child: Text(
                                                  'Show Item info',
                                                  style:  Theme.of(context).textTheme.titleMedium,
                                                )),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  const Spacer(),
                                  showSearchInput
                                      ? Container()
                                      : Row(
                                          children: [
                                            TextButton(
                                              child: Text(
                                                'Find shop',
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  showSearchInput = true;
                                                  content = false;
                                                  showTick3();
                                                });
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.search,
                                                  // color: Colors.orange.shade900
                                                ),
                                              onPressed: () {
                                                setState(() {
                                                  content = false;
                                                  showSearchInput = true;
                                                  showTick3();
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                  if (showSearchInput)
                                    SizedBox(
                                        height: 40,
                                        width: 140,
                                        child: TextField(
                                          focusNode: _searchFocusNode,
                                          controller: searchController,
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.search,
                                              // color:  Colors.orange.shade900,
                                            ),
                                            hintText: 'Shop...',
                                            enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                style: BorderStyle.solid,
                                                width:
                                                    2, // Adjust the border width as needed
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                  style: BorderStyle.solid,
                                                  width: 30,
                                                  color: Colors.indigo),
                                            ),
                                          ),
                                          onChanged: (query) {
                                            filterShops(query);
                                          },
                                          onTap: () {
                                            showTick3();

                                            if (searchController.text.isEmpty) {
                                              tick3 = true;
                                              _searchFocusNode.requestFocus();
                                            }
                                          },
                                        )),
                                  const Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    getCount()
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, int index) {
                                int special= filteredShops[index]['special'];
                                int status = filteredShops[index]['status'];
                                int price = filteredShops[index]['prices'];
                                int quantity = filteredShops[index]['quantity'];
                                String time = filteredShops[index]
                                    ['created_at_timestamp'];
                                String comment =
                                    filteredShops[index]['comment'];

                                var shops = filteredShops[index]['shop'];

                                List<Widget> listTiles = [];

                                for (var shop in shops) {
                                  String shopName = shop['shop_name'];
                                  String shopLocation = shop['location'];
                                  String shopContact = shop['contact'];
                                  String shopInfo = shop['shop_info'];
                                  // String map = shop['map'];
                                  Uri map= Uri.parse(shop['map']);

                                  Uri web = Uri.parse(shop['website']);
                                  Future<void> _launchUrl() async {

                                    print(web);
                                    if (!await launchUrl(web)) {
                                      throw Exception('Could not launch $web');
                                    }
                                  }
                                  Future<void> _launchMap() async {

                                    print(map);
                                    if (!await launchUrl(map)) {
                                      throw Exception('Could not launch $map');
                                    }
                                  }

                                  void _showModal() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Row(children: [


                                               Icon(
                                                Icons.store,


                                              ),

                                            SizedBox( width: 20,),

                                            Text(
                                              shopName,
                                              style:  Theme.of(context).textTheme.titleSmall,
                                            ),
                                          ]),
                                          content: SizedBox(
                                            height: 249,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 90,
                                                  height: 70,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 2, 0, 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          'http://192.168.43.160:8000/storage/${shop['image']}'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                    height: 80,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .orange.shade300
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child:

                                                    Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(5, 0, 0, 0),
                                                      child: Text(
                                                        '$shopInfo.',
                                                        style: Theme.of(context).textTheme.bodyLarge,
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.phone,

                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text('+265$shopContact',
                                                      style: Theme.of(context).textTheme.titleMedium,

                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.gps_fixed_rounded,

                                                        ),

                                                        TextButton(
                                                          onPressed: _launchMap,
                                                          child: Text('Locate us'),
                                                        ),
                                                        // Text(shopLocation)
                                                      ],
                                                    ),

                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.web,

                                                        ),

                                                        TextButton(
                                                          onPressed: _launchUrl,
                                                          child:  Text(
                                                            'Our Website',),
                                                        ),
                                                      ],
                                                    )

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'Close',
                                                style:  Theme.of(context).textTheme.titleMedium,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }

                                  void _showPriceModal() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Column(
                                            children: [
                                              Row(children: [


                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                  ),
                                                  child: Image.network(
                                                    'http://192.168.43.160:8000/storage/${shop['image']}',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),

                                                SizedBox( width: 20,),

                                                Text(
                                                  shopName,
                                                  style:  Theme.of(context).textTheme.titleSmall,
                                                ),


                                              ]),

                                              _divider(),
                                            ],
                                          ),


                                          content: SizedBox(
                                            height: 249,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Quantity:'),
                                                    Spacer(),

                                                     Text('$quantity'),



                                                    ],
                                                ),
                                                Spacer(),

                                                Row(
                                                  children: [
                                                    Text('Price:'),
                                                   Spacer(),
                                                    Text('MK $price'),


                                                  ],
                                                ),
                                               Spacer(),
                                               Row(
                                                 children: [
                                                   Text('Availability:'),
                                                   Spacer(),

                                                   status==1?Text('Available', style: TextStyle(
                                                     color: Colors.green,
                                                   ),): Text('Not Available',style: TextStyle(
                                                     color: Colors.red,),



                                        )],
                                               ),
                                                Spacer(),

                                                Row(
                                                  children: [
                                                    Text('Special Offer:'),

                                                    Spacer(),

                                                    special==1?Text('Normal Price'): Text('On Promotion'),



                                                  ],
                                                ),
                                                Spacer(),
                                                Container(
                                                    height: 80,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .orange.shade300
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          5),
                                                    ),
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child:

                                                    Container(
                                                      margin: const EdgeInsets
                                                          .fromLTRB(5, 0, 0, 0),
                                                      child: Text(
                                                        '$comment.',
                                                        style: Theme.of(context).textTheme.bodyLarge,
                                                      ),
                                                    )),



                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'Close',
                                                style:  Theme.of(context).textTheme.titleMedium,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }


                                  getIcon() {
                                    if (shop['image'] == null) {
                                      return Container(
                                        height: 50,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.lerp(
                                                BorderRadius.circular(2),
                                                BorderRadius.circular(3),
                                                .3)),
                                        child: Icon(
                                          Icons.store,
                                          // color: Colors.orange.shade900,
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 50,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Image.network(
                                          'http://192.168.43.160:8000/storage/${shop['image']}',
                                          fit: BoxFit.fill,
                                        ),
                                      );
                                    }
                                  }

                                  listTiles.add(
                                    Column(
                                      children: [
                                        Container(
                                          child: ListTile(
                                            leading: InkWell(
                                              onTap: _showModal,
                                        child: getIcon(),
                                    ),
                                            title:
                                            InkWell(
                                              onTap: _showModal,
                                              child:Title(
                                                color: Colors.black,
                                                child: Text(
                                                  shopName.length <= 12
                                                      ? shopName
                                                      : '${shopName.substring(0, 12)}...',
                                                  style: Theme.of(context).textTheme.titleSmall,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),


                                            trailing: InkWell(
                                                onTap: _showPriceModal,
                                                child: Column(
                                              children: [

                                                // InkWell(),


                                              Expanded(

                                                      child: Text(time,

                                                        style:  Theme.of(context).textTheme.bodyLarge,
                                                      )

                                                  ),



                                                const Spacer(),
                                                // InkWell()

                                                Text(
                                                    '$quantity @ MK$price',
                                                    style:  Theme.of(context).textTheme.titleSmall,
                                                  ),


                                              ],
                                            )),
                                            subtitle:  InkWell(
                                              onTap: _showModal,
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(
                                                    0, 10, 0, 0),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on,

                                                      size: 18,
                                                    ),
                                                    Text(
                                                      shopLocation,
                                                      style:  Theme.of(context).textTheme.bodyLarge,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),




                                          ),
                                        ),
                                        Divider(
                                          color: Colors.orange.withOpacity(0.1),
                                          thickness: 3,
                                          indent: 5,
                                          endIndent: 5,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Column(children: listTiles);
                              },
                              childCount: filteredShops.length,
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(childCount: 1,
                                (context, int index) {
                            return Column(
                              children: [
                                isLoading
                                    ? Container(
                                  alignment: Alignment.center,
                                  child:  Text('No available shops',style:  Theme.of(context).textTheme.bodyLarge,),
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
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black26,), label: 'Home',),
      //     BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: 'Favorite Items'),
      //     BottomNavigationBarItem(icon: Icon(Icons.info, color: Colors.black26,), label: 'Info'),
      //   ],
      //   currentIndex: selectedIndex,
      //   fixedColor: Colors.orange,
      //   onTap: onItemTapped,
      // ),
    );
  }


  Future<void> saveFavoriteItemIds(List<int> favoriteItemIds) async {
    // print(favoriteItemIds);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoriteItemIds', favoriteItemIds.map((id) => id.toString()).toList());
  }
}


class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
