// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:mobile/screen/home_screen.dart';
// import 'package:mobile/screen/register_screen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // String? url;
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   String error='';
//   String errorText='';
//   bool showPass= true;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//
//
//     // getUrl()async{
//     //
//     //   final SharedPreferences sharedPreferences =
//     //   await SharedPreferences.getInstance();
//     //   var myURL = sharedPreferences.getString('my_url');
//     //
//     //   setState(() {
//     //     // url=myURL;
//     //     print(url);
//     //   });
//     // }
//     void initState() {
//
//       // getUrl();
//
//       super.initState();
//     }
//     Future userLogin(String email,String password)async{
//
//
//
//         try{
//           var data = FormData.fromMap({
//             'email': email,
//             'password': password,
//
//           });
//           var response = await Dio().post('http://192.168.43.160:8000/api/login/', data: data);
//           var dat = response.data;
//
//           if(response.statusCode==200){
//
//
//             Fluttertoast.showToast(
//               msg: "User logged in Successfully",
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 2,
//               backgroundColor: Colors.green,);
//
//             final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//             sharedPreferences.setString('email', email);
//
//             print(email);
//
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
//
//
//           }else{
//             Fluttertoast.showToast(
//               msg: "Invalid details",
//               gravity: ToastGravity.CENTER,
//               timeInSecForIosWeb: 2,
//               backgroundColor: Colors.red,);
//           }
//         }catch(e){
//           print(e);
//         }
//
//
//
//
//     }
//
//     showPassword(){
//       if(showPass==true){
//         setState(() {
//           showPass=false;
//         });
//
//       }else {
//         setState(() {
//           showPass =true;
//         });
//
//       }
//       return showPass;
//     }
//
//
//
//     return Scaffold(
//         body: ScrollConfiguration(
//       behavior: Mybehavior(),
//       child: SingleChildScrollView(
//         child: SizedBox(
//           height: size.height,
//           child: Container(
//             alignment: Alignment.center,
//             constraints: const BoxConstraints.expand(),
//             child: Container(
//               width: size.width * .9,
//               height: size.height * 4.0,
//               child: Column(
//                 children: [
//                   //Image
//
//                   const SizedBox(
//                     height: 80,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
//                     child: Row(
//                       children: [
//                         const Text(
//                           'Welcome to',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 2,
//                         ),
//                         Text(
//                           'P',
//                           style: TextStyle(
//                             color: Colors.orange.shade300.withOpacity(0.9),
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                           ),
//                         ),
//                         const Text(
//                           'rice',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                           ),
//                         ),
//                         Text(
//                           'S',
//                           style: TextStyle(
//                             color: Colors.orange.shade300,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                           ),
//                         ),
//                         const Text(
//                           'avy',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 22,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//
//                     child:  const Text('Please, in below form enter the details that you registered',style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),),
//                   ),
//
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                       child: Container(
//                     child: Column(
//                       children: [
//
//                         Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 75,
//                                 child: TextFormField(
//                                   controller: emailController,
//
//                                   keyboardType: TextInputType.emailAddress,
//                                   style: const TextStyle(
//                                     fontSize: 19,
//                                     height: 0.9,
//
//                                   ),
//                                   validator: (value){
//                                     if(value!.isEmpty){
//                                       error = 'Email is required';
//
//                                     }else return null;
//                                     return error;
//                                   },
//                                   decoration:InputDecoration(
//                                     errorText: error,
//
//                                       border: const OutlineInputBorder(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(30)),
//                                           gapPadding: 6.8),
//                                       labelText: 'Email Address',
//
//                                       // hintText: 'e.g 984786320',
//
//                                       prefixStyle: const TextStyle(
//                                           fontSize: 20,
//                                       height: 4,
//                                      ),
//                                       prefixIcon: const Icon(
//                                         Icons.person,
//                                       )),
//                                 ),
//                               ),
//
//                               const SizedBox(
//                                 height: 10,
//                               ),
//
//                               Container(
//                                 height: 75,
//                                 child:  TextFormField(
//                                   obscureText: showPass,
//                                   controller: passwordController,
//                                   style:const TextStyle(
//                                     fontSize: 19,
//                                     height: 1,
//                                   ),
//                                   validator: (val){
//                                     if(val!.isEmpty){
//                                       errorText = 'Password is required';
//
//                                     }else return null;
//                                     return errorText;
//                                   },
//
//                                   decoration:  InputDecoration(
//                                     errorText: errorText,
//                                     prefixIcon: const Icon(Icons.lock),
//                                     suffixIcon: IconButton(
//                                       onPressed: (){
//
//
//                                         showPassword()
//
//                                         ;},
//                                       icon: Icon(
//                                         showPass?Icons.remove_red_eye_outlined:Icons.remove_red_eye,
//                                       ),
//                                     ),
//                                     // hintText: 'Phone Number',
//                                     labelText: 'Password',
//                                     border: const OutlineInputBorder(
//                                         borderRadius:
//                                         BorderRadius.all(Radius.circular(30)),
//                                         gapPadding: 6.8),
//                                   ),
//                                 ),
//                               ),
//
//
//                             ],
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStatePropertyAll<Color>(
//                                 Colors.orange.shade100.withOpacity(0.9)),
//                             minimumSize: const MaterialStatePropertyAll<Size>(
//                                 Size.fromHeight(50)),
//                           ),
//                           onPressed: () async {
//
//                             if(_formKey.currentState!.validate()){
//
//                               userLogin(emailController.text, passwordController.text);
//
//                             }else {
//
//
//                             }
//
//                           },
//                           child: const Text('Login'),
//                         ),
//
//                         Container(
//
//                           child: Column(
//                             children: [
//                               TextButton(
//                                   onPressed: () {},
//                                   child: const Text('Forgot Password?')),
//
//                               Container(
//                                 margin: const EdgeInsets.fromLTRB(80, 0, 0, 0),
//                                 child:     Row(
//
//                                     children: [
//                                       const Text('Not a Member?'),
//                                       TextButton(
//                                           onPressed: () {
//                                             Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         const RegisterScreen()));
//                                           },
//                                           child: const Text('Register'))
//                                     ]),
//                               )
//
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }
//
// class Mybehavior extends ScrollBehavior {
//   @override
//   Widget buildViewportChrome(
//     BuildContext context,
//     Widget child,
//     AxisDirection axisDirection,
//   ) {
//     return child;
//   }
// }
