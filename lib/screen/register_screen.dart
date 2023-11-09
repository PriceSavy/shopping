
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/screen/home_screen.dart';
import 'package:mobile/screen/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? url;
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController phonenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool showPass= true;
  bool showCon =true;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    showPassword(){
      if(showPass==true){
        setState(() {
          showPass=false;
        });

      }else {
        setState(() {
          showPass =true;
        });

      }
      return showPass;
    }
    showConfirm(){

      if(showCon==true){
        setState(() {
          showCon=false;
        });

      }else {
        setState(() {
          showCon=true;
        });
      }
      return showCon;
    }


    String errorText='';
    String errorText2 ='';
    String errorText1 ='';
    String errorText4='';
    String error='';

    // getUrl()async{
    //
    //   final SharedPreferences sharedPreferences =
    //   await SharedPreferences.getInstance();
    //   var myURL = sharedPreferences.getString('my_url');
    //
    //   setState(() {
    //     url=myURL;
    //   });
    // }
    void initState() {

      // getUrl();

      super.initState();
    }
    Future sendData() async {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }

    Future validateData(String username, String email, String phonenumber,String password,String confirm)async{

      if(password==confirm){

        try{
          var data = FormData.fromMap({
            'username': username,
            'email': email,
            'phone_number': phonenumber,
            'password': password,


          });
          var response = await Dio().post('http://192.168.43.160:8000/api/register/', data: data);
          var dat = response.data;
          print(dat);
          if(dat['message'] == 'User registered successfully'){
            Fluttertoast.showToast(
              msg: "User has been registered Successfully",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,);
            sendData();

          }else if((dat['message'] == 'User already registered')){
            Fluttertoast.showToast(
              msg: "User is already registered",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,);
          }
        }catch(e){
         print(e);
        }

        // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

      }else if(password!=confirm){
        Fluttertoast.showToast(
            msg: "Password does not match",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.deepOrange,
          textColor: Colors.black,
        );
        // Fluttertoast.
        //  ="Passwords does not match";

      }

    }
    return Scaffold(
      body: ScrollConfiguration(

        behavior: Mybehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.expand(),
              child: Container(
                width: size.width*.9,
                height: size.height* 4.0,
                child: Column(
                    children: [
                      //Image

                      SizedBox(height: 30,),
                   Container(
                     padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                     child: Row(
                       children: [
                         Text('Welcome to', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,),),
                         SizedBox(width: 2,),
                         Text('P',style: TextStyle(color: Colors.orange.shade300.withOpacity(0.9),fontWeight: FontWeight.bold, fontSize: 25,),),
                         Text('rice',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,),),
                         Text('S',style: TextStyle(color: Colors.orange.shade300, fontWeight: FontWeight.bold, fontSize: 25,),),
                         Text('avy',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,),),
                       ],
                     ),
                   ),
                      Container(
                        child: Column(
                          children: [
                            Text('To get registered, please enter your details below.',style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),),

                             // Text('Please register below to get started',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),),

                          ],
                        ),

                      ),


                     SizedBox(height: 10,),
                      Container(
                        // height: 250,
                        child: Container(
                          // height: 200,
                          child: Column(
                            children: [
                              // Text('Let us help you find shops to help you buy your product'),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      height: 50, // Set a fixed height for the container
                                      child: TextFormField(
                                        validator: (name) {
                                          if (name!.isEmpty) {
                                            errorText1 = 'Your username is required';
                                          } else {
                                            return null;
                                          }
                                          return errorText1;
                                        },
                                        style: const TextStyle(
                                          fontSize: 19,
                                          height: 1,
                                        ),
                                        controller: usernameController,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                                        ],
                                        decoration: InputDecoration(
                                          hintText: 'e.g Samuel Kazembe',
                                          labelText: 'Full Name*',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                            gapPadding: 6.8,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person_4_outlined,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      height: 70, // Set a fixed height for the container
                                      child: TextFormField(
                                        // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: emailController,
                                        // maxLength: 9,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (email) {
                                          if (email!.isEmpty) {
                                            errorText4 = 'Email is required';
                                          } else {
                                            return null;
                                          }
                                          return errorText4;
                                        },
                                        style: const TextStyle(
                                          fontSize: 19,
                                          // fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          errorText: errorText4,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              gapPadding: 6.8
                                          ),
                                          labelText: 'Email*',
                                          prefixIcon: Icon(
                                            Icons.person,
                                          ),
                                          prefixStyle: const TextStyle(
                                            fontSize: 19,
                                            height: 7,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 60, // Set a fixed height for the container
                                      child: TextFormField(
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        controller: phonenumberController,
                                        maxLength: 9,
                                        keyboardType: TextInputType.number,
                                        validator: (number) {
                                          if (number!.isEmpty) {
                                            errorText1 = 'Phone number is required';
                                          } else if (number.length < 9) {
                                            errorText1 = 'Phone number should be 9';
                                          } else {
                                            return null;
                                          }
                                          return errorText1;
                                        },
                                        style: const TextStyle(
                                          fontSize: 19,
                                          height: 1,
                                          // fontWeight: FontWeight.w300,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              gapPadding: 6.8
                                          ),
                                          labelText: 'Phone Number*',
                                          prefixText: '+265',
                                          prefixIcon: Icon(
                                            Icons.phone,
                                          ),
                                          prefixStyle: const TextStyle(
                                            fontSize: 19,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 70, // Set a fixed height for the container
                                      child: TextFormField(
                                        obscureText: showPass,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          height: 1,
                                          // fontWeight: FontWeight.w300,
                                        ),
                                        controller: passwordController,
                                        validator: (pass) {
                                          if (pass!.isEmpty) {
                                            errorText = " Password is required";
                                          } else if (pass.length < 4) {
                                            errorText = 'Password should be at least 4';
                                          } else {
                                            return null;
                                          }
                                          return errorText;
                                        },
                                        decoration: InputDecoration(
                                          errorText: errorText,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              showPassword();
                                            },
                                            icon: Icon(
                                              showPass ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                            ),
                                          ),
                                          labelText: 'Password*',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              gapPadding: 6.8
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 70, // Set a fixed height for the container
                                      child: TextFormField(
                                        obscureText: showCon,
                                        style: const TextStyle(
                                          fontSize: 19,
                                          height: 1,
                                          // fontWeight: FontWeight.w300,
                                        ),
                                        controller: confirmPassController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            errorText2 = 'Confirm password is required';
                                          } else if (value.length < 4) {
                                            errorText2 = 'Password should be at least 4';
                                          } else {
                                            return null;
                                          }
                                          return errorText2;
                                        },
                                        decoration: InputDecoration(
                                          errorText: errorText2,
                                          prefixIcon: Icon(
                                            Icons.lock,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              showConfirm();
                                            },
                                            icon: Icon(
                                              showCon ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
                                            ),
                                          ),
                                          labelText: 'Confirm Password*',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              gapPadding: 6.8
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.orange.shade100.withOpacity(0.9)),
                                  minimumSize: MaterialStatePropertyAll<Size>(Size.fromHeight(40)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    validateData(
                                      usernameController.text,
                                      emailController.text,
                                      phonenumberController.text,
                                      passwordController.text,
                                      confirmPassController.text,
                                    );
                                  } else {
                                    errorText = "Password is required";
                                    errorText1 = "Phone Number is required";
                                    errorText2 = "Confirm Password is required";
                                    errorText4 = "Email is required";
                                    error = 'Your name is required';
                                  }
                                },
                                child: Text('Submit'),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(80, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Text('Already a registered?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
                                        );
                                      },
                                      child: Text('Login'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),


                      )],
                  ),
              ),
            ),
          ),
        ),
      )
        );
  }
}

class Mybehavior extends ScrollBehavior {
@override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
    ){
  return child;
}
}
