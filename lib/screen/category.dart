import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Map<String, dynamic>> selectedCategories = [];
  List<int> selectedCategoryIds = [];
  List data = [];
  // late bool color;

   String cate ='';
  bool _isSelected(int categoryId) {
    return selectedCategoryIds.contains(categoryId);
  }

  Future getCategories() async {
    try {
      String myUrl = 'http://192.168.43.160:8000/api/items/';
      var response = await http.get(Uri.parse(myUrl));

      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        print('Failed to load categories');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Map<dynamic, List> groupDataByCategories() {
    return groupBy(data, (obj) => obj['categories']);
  }
  // bool _isMounted = false;
  @override
  void initState() {
    super.initState();
    // initialTheme();
    
    // _isMounted = true;
    getCategories();
    getSelectedCategories();
  }
  @override
  void dispose() {
    // _isMounted = false;
    super.dispose();
  }
  // initialTheme()async{
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return   color = prefs.getBool('color')!;
  //
  // }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, List> groupedData = groupDataByCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories',style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor:Colors.white,
        iconTheme: IconThemeData(
          color: Colors.orange.shade900,
          size: 30,
        ),


      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                int category = groupedData.keys.elementAt(index);
                getCat() {
                  if (category == 1) {
                    cate = 'Food and Beverage';
                  } else if (category==
                      2) {
                    cate = 'Digital Services';
                  } else if (category ==
                      3) {
                    cate = 'Cosmetics and Body Care';
                  } else if (category ==
                      4) {
                    cate = 'Furniture and Decor';
                  } else if (category ==
                      5) {
                    cate = 'Electronics';
                  } else if (category ==
                      6) {
                    cate = 'Household';
                  } else if (category ==
                      7) {
                    cate = 'Toys and Hobbies';
                  } else if (category ==
                      8) {
                    cate = 'Pets';
                  } else if (category ==
                      9) {
                    cate = 'Fashion';
                  } else if (category ==
                      10) {
                    cate = 'Others';
                  }
                  return cate;
                }
                return CheckboxListTile(
                  title: Text(getCat()),
                  value: _isSelected(category),
                  onChanged: (bool? value) {
                    int categoryId = category;
                    setState(() {
                      if (value!) {
                        selectedCategoryIds.add(categoryId);
                      } else {
                        selectedCategoryIds.remove(categoryId);
                      }
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: saveSelectedCategories,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void saveSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.setStringList('selectedCategories', selectedCategoryIds.map((id) => id.toString()).toList());



    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }

  Future<void> getSelectedCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? selectedCategoryIdsString = prefs.getStringList('selectedCategories');

    if (selectedCategoryIdsString != null) {
      setState(() {
        selectedCategoryIds = selectedCategoryIdsString.map((id) => int.parse(id)).toList();
      });
    }
  }
}
