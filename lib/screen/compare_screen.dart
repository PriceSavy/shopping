import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? item_name;
String? item_category;
String? item_image;
String? description;
String? item_date;

class CompareItem extends StatefulWidget {
  const CompareItem({super.key});

  @override
  State<CompareItem> createState() => _CompareItemState();
}

class _CompareItemState extends State<CompareItem> {

  @override
  void initState(){
    super.initState();
    getItemData();
  }
  bool showContainer =true;
  bool showContainer1=false;
  bool showContainer2 = false;
  bool showContainer3 = false;
  bool tick = true;
  bool tick2 = false;
  bool tick3 = false;

String name ='Sana';
String price ='1200';


  void showScreen(){
    setState(() {
      showContainer =showContainer1;
      showContainer =true;
      showContainer2= false;
      showContainer3 =false;
      showTick();

    });

  }

  void showScreen2()  {
    setState(() {
      showContainer =false;
      showContainer3 =false;
      showContainer2= true;
      showTick2();


    });
  }
  void showScreen3() {
    setState(() {
      showContainer =false;
      showContainer2= false;
      showContainer3 =true;
      showTick3();


    });
  }
  void showTick(){
    setState(() {
      tick = true;
      tick2 = false;
      tick3 = false;

    });
  }
  void showTick2(){
    setState(() {
     tick = false;
      tick2 = true;
      tick3 = false;
    });
  } void showTick3(){
    setState(() {
      tick = false;
      tick2 = false;
      tick3 = true;
    });
  }
  Future getItemData()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var itemName= sharedPreferences.getString('itemName');
    var itemCate= sharedPreferences.getString('itemCate');
    var itemImage= sharedPreferences.getString('itemImage');
    var itemDesc= sharedPreferences.getString('itemDesc');
    var itemDate= sharedPreferences.getString('itemDate');

    setState(() {
      item_name= itemName!;
      item_category = itemCate;
      item_image = itemImage;
      description = itemDesc;
      item_date = itemDate;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
    body: CustomScrollView(
            slivers:  [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300.0,
                collapsedHeight: 300.0,
                automaticallyImplyLeading: true,
                floating: false,
                backgroundColor: Colors.white,

                actions: [
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
                        onPressed: (){},
                        child: Row(
                          children: [
                            Icon(Icons.category,size: 20,),
                            Spacer(),
                            Text('${item_category}'),
                            Spacer(),

                            Icon(Icons.remove_red_eye_outlined,size: 20,)

                          ],
                        ),
                      )

                  ),

              IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_outlined, color: Colors.indigo.shade300,)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.share_outlined,color: Colors.indigo.shade300,)),
                ],
                flexibleSpace: Container(

                  margin: EdgeInsets.fromLTRB(0, 80, 0, 0),

                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0,0),

                      child: Container(

                          child: Column(
                            children: [


                              Container(
                                height: 150,
                                child: Row(
                                children: [
                                  Container(
                                    height: 250,
                                    margin: EdgeInsets.fromLTRB(10, 2, 1, 0),
                                    width: 180,
                                    //image here
                                    child: Container(

                                      child: Image.network('${item_image}'),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(6, 2, 1, 0),

                                            height: 40,
                                            child: Text('${item_name.toString()}',
                                              style: TextStyle(
                                                color: Colors.black.withOpacity(0.7),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.start,),
                                          ),
                                          _divider(),
                                          Expanded(
                                              child: Text('${description}',
                                            style: TextStyle(
                                                color: Colors.black.withOpacity(0.5),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.start,))

                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(
                                height: 3,
                                thickness: 5,
                                indent: 20,
                                endIndent: 20,
                                color: Colors.orange.withOpacity(0.4),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                             Row(
                               children: [
                                 Spacer(),
                                 TextButton(
                                     style: ButtonStyle(
                                       backgroundColor: tick?MaterialStateProperty.all(Colors.orange.withOpacity(0.5)):MaterialStatePropertyAll(Colors.orange.withOpacity(0.1)),

                                     ),
                                     onPressed: showScreen,
                                     child: Row(
                                       children: [
                                         Text('All',
                                           style: TextStyle( fontSize: 15,
                                             color: Colors.indigo,


                                             fontWeight: FontWeight.bold,),),
                                         tick?Icon(
                                             Icons.check
                                         ):Container(),
                                       ],
                                     )),
                                 Spacer(),

                                 TextButton(
                                     style: ButtonStyle(
                                       backgroundColor: tick2?MaterialStateProperty.all(Colors.orange.withOpacity(0.5)):MaterialStatePropertyAll(Colors.orange.withOpacity(0.1)),


                                     ),
                                     onPressed: showScreen2,
                                     child: Row(
                                       children: [
                                         Text('Favourites',style: TextStyle( fontSize: 15,
                                           color: Colors.indigo,


                                           fontWeight: FontWeight.bold,),),
                                         tick2?Icon(
                                             Icons.check
                                         ):Container(),
                                       ],
                                     )),
                                 Spacer(),
                                 TextButton(
                                     style: ButtonStyle(
                                       // iconSize: MaterialStatePropertyAll(0.9),

                                       backgroundColor: tick3?MaterialStateProperty.all(Colors.orange.withOpacity(0.5)):MaterialStatePropertyAll(Colors.orange.withOpacity(0.1)),


                                     ),
                                     onPressed: showScreen3,
                                     child: Row(
                                       children: [
                                         Text('Near', style: TextStyle( fontSize: 15,
                                           color: Colors.indigo,


                                           fontWeight: FontWeight.bold,)),
                                         tick3?Icon(
                                             Icons.check
                                         ):Container(),
                                       ],
                                     )),
                                 Spacer(),
                               ],
                             ),


                            ],
                          )
                      ))
                ),
              ),


                          SliverGrid(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 350.0,
                              mainAxisSpacing: 1.0,
                              crossAxisSpacing: 25.0,
                              childAspectRatio: 2.0,

                            ),
                            delegate: SliverChildBuilderDelegate(
                              childCount: 1,
                                  (BuildContext context, int index) {
                                return ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context, int index){

                                    if(index==1){
                                      name = 'Chipiku';
                                      price ='1250';

                                    }else if(index==2){
                                      name= 'Shoprite';
                                      price ='1300';

                                    }

                                    return ListTile(
                                     leading: Image(
                                       image: AssetImage('assets/item.webp'),
                                       height: 60,
                                       width: 40,
                                     ),
                                      title: Title(
                                        color: Colors.orange,
                                        child: Text('${name.toUpperCase()} ',
                                          style: TextStyle( fontSize: 15,
                                            color: Colors.black,


                                            fontWeight: FontWeight.bold,),),),
                                      trailing: Container(
                                        child: Text('MK ${price}',
                                            style:
                                            TextStyle( fontSize: 15,


                                            fontWeight: FontWeight.bold,),
                                        ),
                                      ),
                                    );
                                  },

                                );

                              },
                            ),
                          ),
                        ],






          ),


    );


  }


}
Divider _divider(

    ) {
  return Divider(
    color: Colors.orange.withOpacity(0.3),
    thickness: 3,
    indent: 5,
    endIndent: 5,
  );
}
class MyBehavior extends ScrollBehavior{
  @override
  Widget buildViewportChrome(
      BuildContext context,
      Widget child,
      AxisDirection axisDirection,){
    return child;
  }
}
