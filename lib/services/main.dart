

import 'package:flutter/material.dart';
import 'package:mobile/screen/category_screen.dart';

import 'package:mobile/services/ThemeProvider.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

void main() async{


  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(


        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.orange.shade900,
            size: 32.0,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.orange.shade900, // Set the text color
            // Other button-related styles can be set here
          ),
        ),
listTileTheme: ListTileThemeData(
  iconColor: Colors.orange.shade900,
),




        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
          titleSmall: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
          titleMedium: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
          bodyLarge: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 13), // Change the color as needed
        ),

        iconTheme: IconThemeData(
          color:  Colors.orange.shade900,
          size: 20,

        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[100], // Adjust the input field color
          filled: true,



          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color:  Colors.orange.shade900,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
            borderSide:  BorderSide(
              style: BorderStyle.solid,
              width: 30,
              color: Colors.orange.shade900,
            ),
          ),

          // ),
        ),

      ),


      darkTheme: ThemeData.dark().copyWith(
        // Adjust these colors to make your dark theme darker

        scaffoldBackgroundColor: Colors.black,

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,

        ),
        drawerTheme: DrawerThemeData(
        backgroundColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
               color: Colors.black,
             actionsIconTheme: IconThemeData(
               color: Colors.white,
               size: 32.0,
             )

             ),
        iconTheme: IconThemeData(
          color:  Colors.white,
          size: 20,

        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
          titleMedium: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),

            bodyLarge: TextStyle(color: Colors.white,fontWeight: FontWeight.w300,fontSize: 13),

          // titleLarge: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
          titleSmall: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
          // titleMedium: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
          // bodyLarge: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 13),
          // Change the color as needed
            // Change the color as needed
        ),

        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.grey[800], // Adjust the input field color
          filled: true,



          enabledBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2,
              color:  Colors.white,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(30),
            borderSide: const BorderSide(
              style: BorderStyle.solid,
              width: 30,
              color: Colors.orange,
            ),
          ),

          // ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.white, // Set the text color
            // Other button-related styles can be set here
          ),
        ),

      ),
      themeMode: Provider.of<ThemeProvider>(context).currentTheme,

      home:  CategoryScreen(),
    );
  }
}

