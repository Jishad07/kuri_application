

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/CommonWidgets/bottom_nav_bar.dart';
import 'package:kuri_application/CommonWidgets/costom_textformfield.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';


class CreateContributorScreen extends StatefulWidget {
  const CreateContributorScreen({super.key});

  @override
  State<CreateContributorScreen> createState() => _CreateContributorScreenState();
}

class _CreateContributorScreenState extends State<CreateContributorScreen> {
  GlobalKey<FormState>formkey=GlobalKey();
   TextEditingController namecontroller  =TextEditingController();
   TextEditingController phonenumbercontroller =TextEditingController();
   TextEditingController emailcontroller = TextEditingController();
      String image="" ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.amber,
          ),
           Positioned(
            top: Get.height/3.8,
            left: 10,
            child: Text("Register",style: AppTextStyles.heading(),)),
          Positioned(
            top: Get.height/3,

            child: Container(
              decoration: BoxDecoration(
               color: Colors.white ,
                 borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),  // Curve for the top-left corner
               topRight: Radius.circular(40.0), // Curve for the top-right corner
                ),
               ),
               height: Get.height,
               width: Get.width,
              
                
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                   
                    children: [
                      // SizedBox(height: 10,),
                      Stack(
                        children: [
                           CircleAvatar(
                            radius: 75,
                            backgroundColor: AppColors.primaryVariant,
                          ), 
                          Positioned(
                          bottom: 0,
                          right: 0,
                            child: CircleAvatar(
                              // radius: 10,
                              backgroundColor: AppColors.primaryColor,
                            child: IconButton(onPressed: (){}, icon:Icon(CupertinoIcons.camera)),
                            ),
                          ),

                         
                        ],
                      ),
                      SizedBox(height: 20,),
                      CustomTextFormField( namecontroller: namecontroller,hintText: "Enter name ",),
                     SizedBox(height: 20,),
                      CustomTextFormField(namecontroller: emailcontroller,hintText: "Enter Email",),
                                 SizedBox(height: 20,),
                  
                       CustomTextFormField(namecontroller: phonenumbercontroller,hintText: "Enter Phone Number",),

                                  SizedBox(height: 20,), 

                                  GestureDetector(
                                    onTap: () {
                                      // Get.off(CustomBottomNavBar());
                                    },
                                    child: Container(
                                      height: 70,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(25)) ,
                                        color: AppColors.primaryColor
                                      ),
                                      child: Center(child: Text("Register",style: AppTextStyles.heading(),)) ,
                                    ),
                                  )
                  
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

