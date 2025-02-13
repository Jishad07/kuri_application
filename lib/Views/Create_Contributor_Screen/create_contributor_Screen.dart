import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuri_application/CommonWidgets/bottom_nav_bar.dart';
import 'package:kuri_application/CommonWidgets/costom_textformfield.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/AppText/app_texts.dart';
import 'package:kuri_application/Utils/SnackBar/snackbar_helper.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/users/users.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateContributorScreen extends StatefulWidget {
  const CreateContributorScreen({super.key});

  @override
  State<CreateContributorScreen> createState() =>
      _CreateContributorScreenState();
}

class _CreateContributorScreenState extends State<CreateContributorScreen> {
  GlobalKey<FormState> formkey = GlobalKey();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  String image = "";
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  // Save contributor data to database
  _saveContributor() async {
    CollectionReference collRef=FirebaseFirestore.instance.collection('contributors');
    
    if (formkey.currentState!.validate()) {
     
        if (image.isEmpty) {
   SnackbarHelper.showCustomSnackbar(context, AppTexts.imageRequired,);
      return; // Prevent navigation if image is not selected
    }
  
     collRef.add(
      {
        'name': namecontroller.text,
        'email': emailcontroller.text,
        'phoneNumber':phonenumbercontroller.text,
        'image':image
      }
    );
      // String name = namecontroller.text;
      // String phoneNumber = phonenumbercontroller.text;
      // String email = emailcontroller.text;

      // // Create a new Contributor object
      // Contributor contributor = Contributor(
      //   name: name,
      //   phoneNumber: phoneNumber,
      //   email: email,
      //   image: image, // Use the image path or base64 string here
      // );

      // // Insert contributor into the database
      // await dbHelper.insertContributor(contributor);

      // Optionally, clear the form and show a success message
    SnackbarHelper.showCustomSnackbar(context,AppTexts.contributorRegistered);
    Get.to(UsersScreen());
      namecontroller.clear();
      phonenumbercontroller.clear();
      emailcontroller.clear();
       
    }
     
  }

  Future<void> _pickImage() async {
    PermissionStatus status = await Permission.photos.request();
    if (!status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          image = pickedFile.path; // Save the image path
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Permission Denied')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.amber,
          ),
          Positioned(
              top: Get.height / 3.8,
              left: 10,
              child: Text(
                "Register",
                style: AppTextStyles.heading(),
              )),
          Positioned(
            top: Get.height / 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft:
                      Radius.circular(40.0), // Curve for the top-left corner
                  topRight:
                      Radius.circular(40.0), // Curve for the top-right corner
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
                            backgroundImage: image.isNotEmpty
                                ? FileImage(File(image))
                                : null,
                            radius: 75,
                            backgroundColor: AppColors.primaryVariant,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              // radius: 10,
                              backgroundColor: AppColors.primaryColor,
                              child: IconButton(
                                  onPressed: () {
                                    _pickImage();
                                   
                                  },
                                  icon: Icon(CupertinoIcons.camera)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        
                          controller: namecontroller,
                          hintText: AppTexts.enterName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppTexts.nameRequired;
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: emailcontroller,
                        hintText: AppTexts.enterEmail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppTexts.emailRequired;
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return AppTexts.validEmail;
                          }
                          return null; // No error
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      CustomTextFormField(
                          controller: phonenumbercontroller,
                          hintText: AppTexts.enterPhoneNumber,
                          validator: (value) {
                            // Check if the input is empty
                            if (value == null || value.isEmpty) {
                              return AppTexts.phoneNumberRequired;
                            }

                            // Ensure the phone number only contains digits
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return AppTexts.validPhoneNumber;
                            }

                            return null; // No error
                          }),

                      SizedBox(
                        height: 20,
                      ),

                      GestureDetector(
                        onTap: () {
                          _saveContributor();
                         
                          // Get.off(CustomBottomNavBar());
                        },
                        child: Container(
                          height: 70,
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: AppColors.primaryColor),
                          child: Center(
                              child: Text(
                            "Register",
                            style: AppTextStyles.heading(),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
