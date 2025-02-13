import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/images/images.dart';
import 'package:kuri_application/Views/SignUp%20Screen/signupScreen.dart';
import 'package:kuri_application/Views/HomeScreen/homeScreen.dart';

import '../../Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formkey=GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  // Method to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
    // Method to handle login logic (with validation)
  void _login() {

    if (formkey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login process with a delay
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // For now, check if email and password match
        if (_emailController.text == "user@example.com" && _passwordController.text == "password123") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login Successful!')));
          // Navigate to Home Screen
          Get.off(HomeScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid credentials')));
        }
      });
    } else {
      // Show error message if form validation fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill out all fields correctly')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                  Text('Please log in to continue.', style: TextStyle(fontSize: 16, color: Colors.grey)),
              
                  SizedBox(height: 40),
              
                  // Email TextField
                  TextFormField(
                    
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      
                      labelText: 'Email',
                      hintText: 'Enter your email',
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
                        return 'Please enter your email';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                        return 'Please enter a valid email';
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
                      labelText: 'Password',
                      hintText: 'Enter your password',
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
                  buttonlabal: "LogIn" ,
                  width: double.infinity, 
                  height: 50, 
                  buttonColor: AppColors.primaryColor,
                  onPressedCallback: () {
                    // _login();
                   AuthService().signIn(email:_emailController.text , password: _passwordController.text, context: context);
                    // Get.off(HomeScreen());
                  },
                  ),
              
                  SizedBox(height: 20),
              
                  // Don't have an account? Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? ', style: TextStyle(fontSize: 16)),
                      GestureDetector(
                        onTap: () {
                          // Handle Sign Up action
                          Get.to(SignUpScreen());
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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

class Custom_Main_Button extends StatelessWidget {
  double? width;
  double? height;
  Color? buttonColor;
  String? buttonlabal;
  final VoidCallback? onPressedCallback;
   Custom_Main_Button({
    this.width,
    this.height,
    this.buttonColor,
    this.buttonlabal,
   this.onPressedCallback, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: width,  // Width of the button
          height:height
          ,  // Height of the button
          decoration: BoxDecoration(
            color: buttonColor,  // Button background color
            borderRadius: BorderRadius.circular(25),  // Rounded corners
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.5),  // Shadow color
                spreadRadius: 1 ,  // Spread radius of the shadow
                blurRadius: 5,  // Blur effect of the shadow
                offset: Offset(0, 4),  // Position of the shadow
              ),
            ],
          ),
          child: MaterialButton(
         
              // Define the action when the button is clicked
                  onPressed: onPressedCallback,
           
            child: Text(
              buttonlabal??"",  // Button text
              style: TextStyle(
                color: Colors.white,  // Text color
                fontSize: 18,  // Text size
                fontWeight: FontWeight.bold,  // Text weight
              ),
            ),
          ),
        );
  }
}