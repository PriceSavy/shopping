import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:line_icons/line_icons.dart';

class LikedItemsScreen extends StatefulWidget {
  final List<int> favoriteItemIds;
  final List allItemsData;
  LikedItemsScreen({
    required this.favoriteItemIds,
    required this.allItemsData,
  });
  @override
  State<LikedItemsScreen> createState() => _LikedItemsScreenState(favoriteItemIds: favoriteItemIds, allItemsData: allItemsData);

}
class _LikedItemsScreenState extends State<LikedItemsScreen> {
  final List<int> favoriteItemIds;
  final List allItemsData;

  _LikedItemsScreenState({
    required this.favoriteItemIds,
    required this.allItemsData,
  });



  @override
  Widget build(BuildContext context) {



    List likedItems = allItemsData
        .where((item) => favoriteItemIds.contains(item['id']))
        .toList();

    int selectedIndex= 1;void onItemTapped(int index){
      setState(() {
        selectedIndex = index;
        if(index==0){

          Navigator.of(context).pop();

        }if(index==1){

        }if(index==2){

          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));


        }
      });
    }



    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Items'),
      ),
      body: likedItems.isEmpty
          ? const Center(
        child: Text('No liked items yet.'),
      )
          : ListView.builder(
        itemCount: likedItems.length,
        itemBuilder: (context, index) {

          return ListTile(
            title: Text(likedItems[index]['item_name']),

          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.indigo,), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: 'Favorite Items'),
          BottomNavigationBarItem(icon: Icon(Icons.info,color: Colors.indigo,), label: 'Info'),
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.orange,
        onTap: onItemTapped,
      ),
    );
  }
}
