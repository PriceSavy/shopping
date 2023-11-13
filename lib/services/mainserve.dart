import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _preferences;
  bool _isFirstRun = true;
  List<String> selectedCategories = [];
  bool item1 = false;
  bool item2 = false;

  bool item3 = false;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    _preferences = await SharedPreferences.getInstance();
    bool isFirstRun = _preferences.getBool('firstRun') ?? true;

    setState(() {
      _isFirstRun = isFirstRun;
    });

    if (isFirstRun) {
      // Show category selection screen
      _showCategorySelection();
    }
  }

  Future<void> _showCategorySelection() async {
    // Implement your category selection screen here
    // You can use a dialog, a separate screen, or any other UI element

    // For example, a simple dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Categories'),
          content: Column(
            children: [
              // Your category selection UI goes here
              CheckboxListTile(
                title: Text('Category 1'),
                value: item1,
                onChanged: (bool? value) {
                  print('value: selectedCategories.contains $value');

                  _updateSelectedCategories('Category 1', value);
                },


              ),


              CheckboxListTile(
                title: Text('Category 2'),
                value: item2,
                onChanged: (bool? value) {
                  _updateSelectedCategories('Category 2', value);
                },
              ),
              CheckboxListTile(
                title: Text('Category 3'),
                value: item3,
                onChanged: (bool? value) {
                  _updateSelectedCategories('Category 3', value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _saveSelectedCategories();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateSelectedCategories(String category, bool? value) {
    setState(() {
      if (value != null && value) {
        selectedCategories.add(category);
      } else {
        selectedCategories.remove(category);
      }
    });
  }

  Future<void> _saveSelectedCategories() async {
    // Save selected categories and update the firstRun flag
    await _preferences.setStringList('selectedCategories', selectedCategories);
    await _preferences.setBool('firstRun', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Selection Demo'),
      ),
      body: Center(
        child: _isFirstRun
            ? CircularProgressIndicator() // Show loading indicator during the first run
            : Text('Welcome to the App!'),
      ),
    );
  }
}

