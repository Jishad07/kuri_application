import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:kuri_application/Theme/contributors_service.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/Create_Contributor_Screen/create_contributor_Screen.dart';
import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Models/contributors_model.dart';
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
        final CollectionReference fetchContributors=
      FirebaseFirestore.instance.collection('contributors');
   final DatabaseHelper dbHelper = DatabaseHelper.instance;
 List<ContributorModel> contributors = [];
    bool isLoading = true;
    String? errorMessage;

  @override
  void initState(){
  _fetchContributors();
    
    
  }
  Future<void> _fetchContributors() async {
    try {
      final fetchedContributors = await ContributorsService().fetchContributors();
      setState(() {
        contributors = fetchedContributors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading contributors: $e';
        isLoading = false;
      });
    }
  }
   void _deleteContributor(Contributor contributor,String name) async {

  await DatabaseHelper.instance.deleteContributor(contributor.id!);

  setState(() {
      contributors.remove(contributor);  
  });

  // Show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${name} Contributor deleted!')),
  );
   }
    void _showBottomSheet(Contributor contributor) {
    showModalBottomSheet(
      context: context,
      // shape: RoundedRectangleBorder(
      //    borderRadius: BorderRadius.only(
      //   topLeft: Radius.circular(50.0), // Adjust the curve on the top-left corner
      //   topRight: Radius.circular(50.0), // Adjust the curve on the top-right corner
      // ),
      // ),
      builder: (BuildContext context) {
        return Container(
         
          padding: EdgeInsets.all(20),
          height: 200, // Adjust the height of the bottom sheet as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Options for ${contributor.name}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(CupertinoIcons.pen, color: Colors.blue),
                title: Text("Edit"),
                onTap: () {
                  // updateContributor();
                  // Implement Edit functionality here
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(CupertinoIcons.delete_solid, color: Colors.red),
                title: Text("Delete"),
                onTap: () {
                
                  _deleteContributor(contributor,contributor.name);
               
                  Navigator.pop(context); 
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: 
          
          Text('Users Screen'),
          centerTitle: true,
        ),
                 floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateContributorScreen());
          // Implement add user functionality
        },
        backgroundColor: AppColors.secondaryColor,
        child: Icon(Icons.add),
      ),
        body:
        // StreamBuilder(
        //   stream: fetchContributors.snapshots(), 
        //   builder: (context,AsyncSnapshot<QuerySnapshot>streamSnapshot){
        //     if(streamSnapshot.hasData){
        //       return ListView.separated(
        //         itemBuilder: (context, index){
        //      final DocumentSnapshot documentSnapshot= streamSnapshot.data!.docs[index];
        //      return Card(
        //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        //             elevation: 4,
        //           child: ListTile(
        //             leading: CircleAvatar(
        //               radius: 50,
        //               backgroundImage: FileImage(File(documentSnapshot['image'])),
        //             ),
        //           title: Text(documentSnapshot['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        //             subtitle: Text(documentSnapshot['phoneNumber']),
        //             trailing: IconButton(onPressed: (){
        //                 // _showBottomSheet();
        //             },
        //             icon:Icon(CupertinoIcons.ellipsis_vertical_circle))
        //      )
        //      );
        //         },
        //          separatorBuilder: (context,index){
        //        return SizedBox(height: 5,);
        //          }, 
        //          itemCount: streamSnapshot.data!.docs.length);
        //     }
        //     else{
        //       return Center(
        //       child: CircularProgressIndicator(),
        //      );
        //     }
           
        //   }
          
        //   )


        isLoading?
        // contributors.isEmpty?
        Center(child:
         CircularProgressIndicator(),
         ):contributors.isEmpty?
         Center(child: Text("Contributors are Empty"),):
         ListView.separated(
            itemBuilder: (context, index) {
               ContributorModel contributor = contributors[index];
              return 
              Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: 
                      // NetworkImage(contributor.image)
                      FileImage(File(contributor.image)),
                    ),
              
                    title: Text(contributor.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contributor.phoneNumber),
                    trailing: IconButton(onPressed: (){
                     
                          // _showBottomSheet(contributor);
                   
                     
                    }, icon:Icon(CupertinoIcons.ellipsis_vertical_circle))
                    ,
              
                  ),
                );
         
            },
            separatorBuilder: (context,index ) {
              return SizedBox(height: 5,);
            },
            itemCount: contributors.length
            )

            );
    
  }
  
}


