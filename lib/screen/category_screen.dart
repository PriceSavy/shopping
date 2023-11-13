import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  List<Map<String, dynamic>> selectedCategories = [];

  List<int> selectedCategoryIds = [];

  List data =[];

  bool _isSelected(int categoryId) {
    return selectedCategoryIds.contains(categoryId);
  }
  Future getCategories() async {

    try{

      String myUrl = 'http://192.168.43.160:8000/api/items/';

      var response = await http.get(Uri.parse(myUrl));
      data = jsonDecode(response.body);
       // print(data);
      if (response.statusCode == 200) {
        setState(() {

          data = json.decode(response.body);



        });



      }else{
        print('Failed to load categories');

      }

    }catch(e){

      print('Error: $e');

    }
  }
  Map<dynamic, List> groupDataByCategories() {
    return groupBy(data, (obj) => obj['categories']);
  }
  @override
  void initState() {
    super.initState();
    getCategories();
  }
  @override
  Widget build(BuildContext context) {

    Map< dynamic, List> groupedData = groupDataByCategories();

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: groupedData.length,
        itemBuilder: (context, index) {
          int category = groupedData.keys.elementAt(index);
          // List categoryItems = groupedData[category]!;




          return CheckboxListTile(
            title: Text('$category'),
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
              }
                      ,
          );
        },
      ),
    );
  }



  getSelected(){



  }

  // void _updateSelectedCategories(String category, bool? value) {
  //   // Your logic to update the selected categories
  // }
}
