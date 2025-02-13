import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/CommonWidgets/costom_textformfield.dart';
import 'package:kuri_application/Services/auth_service.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/AppText/app_texts.dart';
import 'package:kuri_application/Utils/images/images.dart';
import 'package:kuri_application/Views/LogInScreen/logInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 
  bool _obscureText = true;
  final GlobalKey<FormState> formkey=GlobalKey();
  TextEditingController _namecontroller=TextEditingController();
  TextEditingController _phoneNumbercontroller=TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  TextEditingController _conformPassword=TextEditingController();


    void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo or Icon
                  // Icon(Icons.account_circle, size: 100, color: Colors.blue),
                  CircleAvatar(
                  radius: 50 ,
                    backgroundImage: AssetImage(Images.kuri_main_logo),),
                  SizedBox(height: 20),
                  // Welcome Text
                  Text('Welcome Back!', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              
                  SizedBox(height: 10),
                  Text('Please Sign Up', style: TextStyle(fontSize: 16, color: Colors.grey)),
              
                  SizedBox(height: 40),
              
                  // Email TextField
                 
                  CustomTextFormField(
                    controller: _namecontroller,
                    hintText: "Name",
                    // label: Text('Name',),
                    borderColor:Colors.black,
                    keyboardType:TextInputType.name ,
                    decoration: InputDecoration(

                      // label: Text('Name',),
                      // hintText: AppTexts.enterEmail,
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      
                    ),
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                   SizedBox(height: 20,),
                     CustomTextFormField(
                      hintText: "Email",
                      // label: Text("Email"),
                      borderColor: Colors.black,
                    controller: _emailController,
                    keyboardType:TextInputType.emailAddress ,
                    decoration: InputDecoration(
                      
                     
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      
                    ),
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }      
                        if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                   SizedBox(height: 20,),
                     CustomTextFormField(
                    controller: _phoneNumbercontroller,
                    keyboardType:TextInputType.number ,
                    borderColor: Colors.black,
                    // label: Text("Phone Number"),
                    hintText: "phone Number",
                    decoration: InputDecoration(
                     
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      focusedBorder: OutlineInputBorder(
                        
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      
                    ),
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
              
                  SizedBox(height: 20),
              
                  // Password TextField
                  TextFormField(
                     
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      // labelText: 'Password',
                      hintText:  
                      'password',
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20,),
                   TextFormField(
                     
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      // labelText: 'Conform Password',
                      hintText:  "Conform Password",
                      prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
              
                  SizedBox(height: 30),
              
                  // Login Button
                 Custom_Main_Button( 
                  buttonlabal: "Sign Up" ,
                  width: double.infinity, 
                  height: 50, 
                  buttonColor: AppColors.primaryColor,
                  onPressedCallback: ()async {
                    // _login();
                 await  AuthService().signUp(context:context,email: _emailController.text,password: _passwordController.text,name: _namecontroller.text,phoneNumber: _phoneNumbercontroller.text);
                
                    // Get.off(HomeScreen());
                  },
                  ),
              
               
              
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}