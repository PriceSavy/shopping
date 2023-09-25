import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../screen/compare_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controllers extends StatefulWidget {
  // const Controllers({Key? key}) : super(key: key);



  // final GlobalKey<_ControllersState> key;
  final GlobalKey<_ControllersState> controllerKey;

  Controllers({Key? key, required this.controllerKey}) : super(key: key);

  @override
  State<Controllers> createState() => _ControllersState();

  void filterData(String query) {


  }
}
class _ControllersState extends State<Controllers> {

  List data = [];

  int count =1;
  bool fav = false;
  Color favoriteColor = Colors.black26;
  List filteredData = [];
  getCount(){
    if (data.length==0){
      return count;
    }else
    return data.length;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    String myUrl = 'http://192.168.43.160:8000/api/items/';

    var response = await http.get(Uri.parse(myUrl));
    data = jsonDecode(response.body);



    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);

        filteredData =data;
        // print(data);
        // print('zikutheka aise');
        // print(data.toString());
      });
    } else {
      log('data failed');
      throw Exception('Failed to load');
    }


  }



  bool show = true;

  // late Future<List> ItemInfo items;
  bool showDrawer = false;
  String apiUrl = 'items';
  String image = 'assets/item.webp';
  String name = 'Butter Chicken Keto Bone Broth';
  String cate = 'Food';
  bool data_finished = false;
  TextEditingController favorite = TextEditingController();




  DataFinished() {
    if (data.last) {
    setState(() {
      data_finished =true;
    });


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


  @override
  Widget build(BuildContext context) {



    Color _favIconColor = Colors.grey;
    Size size = MediaQuery.of(context).size;

    return SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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

               favoriteColor =Colors.red;
               return Icon(

                 Icons.favorite_outlined,



               );

             } else if (filteredData[index]['favorite'] == 0) {
               favoriteColor =Colors.indigo.shade300;

               return Icon(
                 Icons.favorite_outline,

               );
             }
           }
    getCate(){
      if(filteredData[index]['categories']==1){

          cate= 'Food and Beverage';


      }else if(filteredData[index]['categories']==2){

          cate= 'Digital Services';
      }else if(filteredData[index]['categories']==3){

        cate= 'Cosmetics and Body Care';
      }else if(filteredData[index]['categories']==4){

        cate= 'Furniture and Decor';
      }else if(filteredData[index]['categories']==5){

        cate= 'Electronics';
      }else if(filteredData[index]['categories']==6){

        cate= 'Household';
      }else if(filteredData[index]['categories']==7){

        cate= 'Toys and Hobbies';
      }else if(filteredData[index]['categories']==8){

        cate= 'Pets';
      }else if(filteredData[index]['categories']==9){

        cate= 'Fashion';
      }else if(filteredData[index]['categories']==10){

        cate= 'Others';
      }
      return cate;

    }

    CompareScreen() async{

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('itemName', filteredData[index]['item_name']);
      sharedPreferences.setString('itemCate', cate);
      sharedPreferences.setString('itemImage', filteredData[index]['image_url']);
      sharedPreferences.setString('itemDesc', filteredData[index]['description']);
      sharedPreferences.setString('itemDate', filteredData[index]['created_at_timestamp']);
      // sharedPreferences.setString('itemName', item['item_name']);


    }


            if (filteredData.isNotEmpty && index < filteredData.length) {
              return Expanded(child: Column(children: [
                Expanded(

                  child:Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                          )),
                      alignment: Alignment.center,
                      // color: Colors.teal[100 * (index % 9)],
                      child: InkWell(
                        onTap: () async{
                          CompareScreen();


                          Navigator.push(context, MaterialPageRoute(builder: (context) => CompareItem()));
                        },
                        child: Container(
                          color: Colors.white,
                          //lIST OF ITEAMS
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),

                                // color: Colors.white.withOpacity(0.1),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 200,
                                        height: 35,
                                        margin: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.orange.withOpacity(0.1),
                                        ),
                                        // color: Colors.black12.withOpacity(0.3),
                                        child: TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.category,
                                                size: 20,
                                              ),
                                              Spacer(),
                                              Text('${getCate()}'),
                                              Spacer(),
                                              Icon(
                                                Icons.remove_red_eye_outlined,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        )),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Text(
                                        ' ${filteredData[index]['created_at_timestamp']}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 0, 70, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      padding: EdgeInsets.fromLTRB(0, 0, 70, 0),
                                      child:
                                      Text(
                                        '${filteredData[index]['item_name'].toString().trimLeft()}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      padding: EdgeInsets.fromLTRB(0, 0, 55, 0),
                                      child: Text(
                                        'Click to Compare Prices',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          color: Colors.black.withOpacity(0.9),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 2, 0, 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Image.network(
                                    '${filteredData[index]['image_url']}',
                                    fit: BoxFit.fill,),
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
                                          color: Colors.indigo.shade300,
                                        ),
                                        hoverColor: Colors.amber,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.outlined_flag_outlined,
                                          color: Colors.indigo.shade300,
                                        ),
                                        hoverColor: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                      child:

                                      IconButton(


                                        // highlightColor: favoriteColor,
                                          icon: Icon(
                                            getIcon()?.icon,
                                            color: favoriteColor,

                                          ),
                                          tooltip: 'Add to favorite',
                                          onPressed: () {

                                            if(filteredData[index]['favorite']==1){

                                              setState(() {
                                                filteredData[index]['favorite']=0;


                                              });
                                            }else if(filteredData[index]['favorite']==0)
                                              setState(() {
                                                filteredData[index]['favorite']=1;

                                              });
                                          }

                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )), ),
              ]),);
            } else{
              return Container(child: Text('no data',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),),
            );
            }}

          ,childCount: getCount(),
        ));
          }
  }

Divider _divider() {
  return Divider(
    color: Colors.orange.withOpacity(0.1),
    thickness: 3,
    indent: 15,
    endIndent: 15,
  );
}