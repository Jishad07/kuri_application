import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Views/Create_Contributor_Screen/create_contributor_Screen.dart';
import 'package:kuri_application/Views/WalkthroghScreen/walkthroug_first_screen.dart';

class WalkthroughLastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
           Container(
            width: Get.width,
            height: Get.height/1.5,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
               borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))
            ),
           ),
             Container(
              height: Get.height/3,
              
               child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                  SizedBox(height: 50,),
                   Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize:24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                   ),
                       Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0), // Adjust padding for the button
                  child: IconButton(
                    onPressed: () {
                      Get.off(CreateContributorScreen());
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
                      radius: 5,
                      backgroundColor:Colors.black ,
                
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.black,
                    ),
                     SizedBox(width: 5,), 
                    CircleAvatar(
                      radius: 5, 
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(width: 5,),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.amber ,
                    ),
                
                  ],
                )
              ],
            ),
                 ],
               ),
             ),
          
          ],
        ),
      ),
    );
  }
}



