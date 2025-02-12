import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/Create_Contributor_Screen/create_contributor_Screen.dart';
import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
   final DatabaseHelper dbHelper = DatabaseHelper.instance;
     List<Contributor> contributors = [];
      bool isLoading = true;
  @override
  void initState(){
   _fetchContributors();
    
    
  }
   _fetchContributors() async {
    Future.delayed(Duration(seconds: 3),()async{
    final List<Contributor> fetchedContributors = await dbHelper.getContributors();
    setState(() {
      contributors = fetchedContributors;
      isLoading = false;
    });
    });

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
        body:isLoading?
        // contributors.isEmpty?
        Center(child:
         CircularProgressIndicator(),
         ):contributors.isEmpty?
         Center(child: Text("Contributors are Empty"),):
         ListView.separated(
            itemBuilder: (context, index) {
               Contributor contributor = contributors[index];
              return 
              Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(File(contributor.image)),
                    ),
              
                    title: Text(contributor.name, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(contributor.phoneNumber),
                    trailing: IconButton(onPressed: (){
                     
                          _showBottomSheet(contributor);
                   
                     
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


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart'; // Import the controller
// import 'package:kuri_application/Models/Contributor.dart';
// import 'package:kuri_application/Utils/AppColor/appColors.dart';
// import 'dart:io';

// import '../../Controls/contributor_controller.dart'; // For FileImage usage

// class UsersScreen extends StatelessWidget {

//   const UsersScreen({super.key});


//       void _showBottomSheet(Contributor contributor) {
//     showModalBottomSheet(
//       context: context,
//       // shape: RoundedRectangleBorder(
//       //    borderRadius: BorderRadius.only(
//       //   topLeft: Radius.circular(50.0), // Adjust the curve on the top-left corner
//       //   topRight: Radius.circular(50.0), // Adjust the curve on the top-right corner
//       // ),
//       // ),
//       builder: (BuildContext context) {
//         return Container(
         
//           padding: EdgeInsets.all(20),
//           height: 200, // Adjust the height of the bottom sheet as needed
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Options for ${contributor.name}",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 20),
//               ListTile(
//                 leading: Icon(CupertinoIcons.pen, color: Colors.blue),
//                 title: Text("Edit"),
//                 onTap: () {
//                   // updateContributor();
//                   // Implement Edit functionality here
//                   Navigator.pop(context); // Close the bottom sheet
//                 },
//               ),
//               ListTile(
//                 leading: Icon(CupertinoIcons.delete_solid, color: Colors.red),
//                 title: Text("Delete"),
//                 onTap: () {
                
//                   _deleteContributor(contributor);
//                   // Implement Delete functionality here
//                   Navigator.pop(context); // Close the bottom sheet
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Initialize ContributorController and fetch contributors
//     final ContributorController contributorController = Get.put(ContributorController());
//     contributorController.fetchContributors();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Users Screen'),
//         centerTitle: true,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Implement add user functionality
//         },
//         backgroundColor: AppColors.secondaryColor,
//         child: Icon(Icons.add),
//       ),
//       body: Obx(() {
//         // When contributors list is empty, show a loading indicator
//         if (contributorController.contributors.isEmpty) {
//           return Center(child: CircularProgressIndicator());
//         } else {
//           return ListView.separated(
//             itemBuilder: (context, index) {
//               Contributor contributor = contributorController.contributors[index];
//               return 
//                            Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   elevation: 4,
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: FileImage(File(contributor.image)),
//                     ),
              
//                     title: Text(contributor.name, style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Text(contributor.email),
//                     trailing: IconButton(onPressed: (){
                     
//                           _showBottomSheet(contributor,);
                   
                     
//                     }, icon:Icon(CupertinoIcons.ellipsis_vertical_circle))
//                     ,
              
//                   ),
//                 );
//             },
//             separatorBuilder: (context, index) => SizedBox(height: 5),
//             itemCount: contributorController.contributors.length,
//           );
//         }
//       }),
//     );
//   }
// }
