


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Views/WalkthroghScreen/walkthrough_second_screen.dart';

class WalkTroughFirstScreen
 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/moneybackground.jpg"),
            fit: BoxFit.cover, // Ensures the image covers the entire screen
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Puts everything at the bottom
          children: [
            // Text right above the button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Adjust vertical space
              child: Text(
                'Every month, everyone contributes ₹5000, and a lucky winner gets the pooled amount.',
                style: TextStyle(
                  fontSize: 20.0, // Adjust font size
                  fontWeight: FontWeight.bold, // Makes the text bold
                  color: Colors.white, // Text color
                  letterSpacing: 1.2, // Letter spacing for readability
                  height: 1.3, // Line height for spacing between lines
                ),
                textAlign: TextAlign.center, // Center-align the text
              ),
            ),
            
            // The button right below the text
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0), // Adjust padding for the button
                  child: IconButton(
                    onPressed: () {
                    // Get.off(WalkthroughSecondScreen());
                    Get.to(WalkthroughSecondScreen(),transition: Transition.fade,duration: Duration(milliseconds: 900));
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: Colors.amber, 
                      size: 50,
                    ),
                  ),
                  
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor:Colors.amber ,
                
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                     SizedBox(width: 5,), 
                    CircleAvatar(
                      radius: 5, 
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.white,
                    ),
                
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
