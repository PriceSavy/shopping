import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile/api/controllers.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
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
  final bool isLiked;
  final Function(bool) onLikedStatusChanged;
  final GlobalKey<FormFieldState<String>> textFieldKey;
  CompareItem({
    required this.isLiked,
    required this.onLikedStatusChanged,
    required this.textFieldKey,
  });
  @override
  State<CompareItem> createState() => _CompareItemState(isLiked: isLiked, textFieldKey: textFieldKey);
}
class _CompareItemState extends State<CompareItem> {
  bool isLiked;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormFieldState<String>> textFieldKey;
  _CompareItemState({required this.isLiked,required this.textFieldKey});
  final Uri _url = Uri.parse('https://flutter.dev');

  @override
  void initState() {
    getItemData();

    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = true;
      });
    });  }
  final TextEditingController searchController = TextEditingController();
  bool showContainer = true;
  bool showContainer1 = false;
  bool showContainer2 = false;
  bool showContainer3 = false;
  bool showSearchInput = false;
  bool content =true;
  bool count=true;
  final FocusNode _searchFocusNode = FocusNode();

  bool tick = true;
  bool tick2 = false;
  bool tick3 = false;
  List data = [];
  List<int> favoriteShopId = [];
  void updateLikedStatus(int itemId, bool isLiked) {
    setState(() {
      if (isLiked) {
        favoriteShopId.add(itemId);
      } else {
        favoriteShopId.remove(itemId);
      }
    });
  }
  List<dynamic> filteredShops = [];
  void showScreen() {
    setState(() {
      showContainer = showContainer1;
      showContainer = true;
      showContainer2 = false;
      showContainer3 = false;
      showSearchInput =false;
      showTick();
    });
  }

  void showScreen2() {
    setState(() {
      showContainer = false;
      showContainer3 = false;
      showContainer2 = true;
      showSearchInput =false;
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
      showSearchInput =false;
    });
  }

  void showTick2() {
    setState(() {
      tick = false;
      tick2 = true;
      tick3 = false;
      showSearchInput =false;
    });
  }

  void showTick3() {
    setState(() {
      tick = false;
      tick2 = false;
      tick3 = true;

    });
  }

  Future getItemData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var itemId = sharedPreferences.getInt('item_id');
    var itemName = sharedPreferences.getString('itemName');
    var bar_code = sharedPreferences.getInt('barCode');
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
      barcode = bar_code;
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
        filteredShops=data;
        showSearchInput = false;
        content =true;
        print(data);
      });
    }
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

  getCount(){
    if(filteredShops.isEmpty){
      setState(() {
        count =false;
      });


    }else{
      setState(() {
        count =true;
      });

    }
    return count;
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
                    expandedHeight: content?300.0:150,
                    collapsedHeight: content?325.0:80,
                    automaticallyImplyLeading: true,
                    floating: false,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.indigo,
                        size: 32.0,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return HomeScreen();
                        })).then((_) {
                          textFieldKey.currentState?.reset();
                        });

                      },
                    ),
                    actions: [
                      Container(
                        width: 220,
                        height: 39,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.orange.withOpacity(0.1),
                        ),
                        // color: Colors.black12.withOpacity(0.3),
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [

                              const Spacer(),
                              Text(
                                item_name.toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),

                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: isLiked
                            ? Icon(
                          Icons.favorite,
                          color: Colors.indigo.shade300,
                        )
                            : Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.indigo.shade300,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.share_outlined,
                          color: Colors.indigo.shade300,
                        ),
                      ),
                    ],
                    flexibleSpace: Container(
                      height: 300,
                      margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                      child: Container(
                        height: 300,
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Column(
                          children: [
                          content?  SizedBox(
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 200,
                                    margin: const EdgeInsets.fromLTRB(5, 0, 0, 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '$item_image'),
                                        fit: BoxFit
                                            .fill,
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
                                              margin: const EdgeInsets.fromLTRB(
                                                  8, 2, 1, 0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 120, 0),
                                                    child: Text(
                                                      'Size: $sizeItem',
                                                      style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.9),
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                      TextAlign.start,
                                                      textWidthBasis:
                                                      TextWidthBasis
                                                          .parent,
                                                    ),
                                                  ),



                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .qr_code_2_outlined,
                                                        size: 14,
                                                      ),
                                                      Text(
                                                        '$barcode',
                                                        style: TextStyle(
                                                          color: Colors
                                                              .black
                                                              .withOpacity(
                                                              0.9),
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                        textAlign:
                                                        TextAlign.start,
                                                      ),
                                                    ],
                                                  ),

                                                  _divider(),
                                                ],
                                              )),
                                          Container(
                                              height: 130,
                                              margin: const EdgeInsets.fromLTRB(
                                                  0, 2, 0, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    description.toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w300,
                                                      color: Colors.black
                                                          .withOpacity(0.9),
                                                      fontSize: 15,
                                                    ),
                                                    textAlign:
                                                    TextAlign.start,
                                                    textWidthBasis:
                                                    TextWidthBasis.parent,
                                                  ),
                                                ],
                                              )),],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ):Container(),

                            Row(
                              children: [
                               const SizedBox(
                                 width: 10,
                               ),
                                TextButton(

                                  onPressed: showScreen,
                                  child: Row(
                                    children: [
                                      content?const Text(
                                        'Available Shops',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ): TextButton(onPressed: (){
                                        setState(() {
                                          content=true;
                                          showSearchInput =false;
                                        });
                                      }, child: const Text(
                                        'Show Item info',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                const Spacer(),
                                showSearchInput?Container():
                              Row(
                                children: [
                                  TextButton(
                                    child: const Text('Find shop'),
                                    onPressed: () {
                                      setState(() {
                                        showSearchInput = true;
                                        content=false;
                                        showTick3();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      setState(() {
                                        content=false;
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
                                    width: 150,
                                    child:
                                    TextField(
                                      focusNode:_searchFocusNode,
                                      controller: searchController,

                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Colors.indigo,

                                        ),
                                        hintText: 'Shop...',
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            style: BorderStyle.solid,
                                            width: 2, // Adjust the border width as needed
                                            color: Colors.indigo,
                                          ),
                                        ),
                                        border: UnderlineInputBorder(

                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(

                                              style: BorderStyle.solid,

                                              width: 30,
                                              color: Colors.indigo
                                          ),

                                        ),
                                      ),
                                      onChanged: (query) {
                                        filterShops(query);
                                      },
                                      onTap: (){
                                       showTick3();

                                        if (searchController.text.isEmpty) {

                                          tick3 = true;
                                          _searchFocusNode.requestFocus();
                                        }

                                      },
                                    )

                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),




                  getCount() ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, int index) {

                        int itemId = filteredShops[index]['item_id'];
                        int userId = filteredShops[index]['user_id'];
                        int price = filteredShops[index]['prices'];
                        int quantity = filteredShops[index]['quantity'];
                        String time = filteredShops[index]['created_at_timestamp'];
                        String comment = filteredShops[index]['comment'];

                        var shops = filteredShops[index]['shop'];

                        List<Widget> listTiles = [];

                        for (var shop in shops) {
                          String shopName = shop['shop_name'];
                          String shopLocation = shop['location'];
                          String shopContact = shop['contact'];
                          String shopInfo = shop['shop_info'];
                          Future<void> _launchUrl() async {
                            if (!await launchUrl(_url)) {
                              throw Exception('Could not launch $_url');
                            }
                          }

                          void _showModal() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(
                                    children: [
                                      Text(
                                        shopName,
                                        style: TextStyle(
                                          color:
                                          Colors.black.withOpacity(0.9),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon:  Icon( favoriteShopId.contains(filteredShops[index]['id'])
                                            ? Icons.favorite

                                            :Icons.favorite_border_outlined,
                                            color: Colors.indigo.shade300
                                        ),

                                          onPressed: () {

                                            if (favoriteShopId.contains(filteredShops[index]['id'])) {
                                              // Remove it from favorites
                                              setState(() {
                                                favoriteShopId.remove(filteredShops[index]['id']);
                                              });
                                            } else {
                                              // Add it to favorites
                                              setState(() {
                                                favoriteShopId.add(filteredShops[index]['id']);
                                              });
                                            }


                                          },

                                      ),
                                    ]
                                  ),
                                  content: SizedBox(
                                    height: 249,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 70,
                                          margin:
                                          const EdgeInsets.fromLTRB(0, 2, 0, 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://192.168.43.160:8000/storage/${shop['image']}'),

                                              fit: BoxFit
                                                  .fill,
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
                                              color: Colors.orange.shade300
                                                  .withOpacity(0.1),
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  5, 0, 0, 0),
                                              child: Text(
                                                '$shopInfo.',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black
                                                      .withOpacity(0.9),
                                                  fontSize: 15,
                                                ),
                                              ),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text('+265$shopContact'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on),
                                                Text(shopLocation)
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: _launchUrl,
                                              child: const Text('Our Website'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
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
                                child: const Icon(
                                  Icons.store,
                                ),
                              );
                            } else {
                              return Container(
                                height: 50,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
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
                                InkWell(
                                  onTap: _showModal,
                                  child: ListTile(
                                    leading: getIcon(),
                                    title: Title(
                                      color: Colors.black,
                                      child: Text(
                                        '${shopName.length <= 12
                                            ? shopName
                                            : '${shopName.substring(0, 12)}...'} ',
                                        style: TextStyle(
                                          color:
                                          Colors.black.withOpacity(0.9),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    trailing: Container(
                                        child: Column(
                                          children: [
                                            Expanded(child: Text(time)),
                                            const Spacer(),

                                            Text(
                                              '$quantity @ MK$price',
                                              style: const TextStyle(
                                                fontSize: 17,

                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                          ],
                                        )),
                                    subtitle: Container(
                                      margin:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 17,
                                          ),
                                          Text(
                                            shopLocation,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black
                                                  .withOpacity(0.9),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
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



                        return Column(
                            children:


                            listTiles


                        );
                      },
                      childCount: filteredShops.length,
                    ),
                  ) :
                  SliverList(
                      delegate: SliverChildBuilderDelegate(


                          childCount: 1,
                              (context, int index) {
                            return Column(
                              children: [
                                isLoading?
                                Container(
                                  alignment: Alignment.center,
                                  child: const Text('No available shops'),
                                )

                                :const Center(
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
    ));
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
