import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
   final DatabaseHelper dbHelper = DatabaseHelper.instance;
     List<Contributor> contributors = [];
  @override
  void initState(){
   _fetchContributors();
    
    
  }
   _fetchContributors() async {
    final List<Contributor> fetchedContributors = await dbHelper.getContributors();
    setState(() {
      contributors = fetchedContributors;
    });
  }
  @override
  Widget build(BuildContext context) {
    //  List<String> names = [
    //   'Jishad',
    //   'Nimesh',
    //   'Bashid',
    //   'Akhil',
    //   'Achu',
    //   'Appu',
    //   'Hafeef',
    //   'Zakariya',
    //   'Roopesh',
    //   'Suni',
    // ];

    // List<String> phoneNumbers = [
    //   '9847298705',
    //   '9847298706',
    //   '9847298707',
    //   '9847298708',
    //   '9847298709',
    //   '9847298710',
    //   '9847298711',
    //   '9847298712',
    //   '9847298713',
    //   '9847298714',
    // ];
    return Scaffold(
        appBar: AppBar(
          title: 
          
          Text('Users Screen'),
          centerTitle: true,
        ),
        body:contributors.isEmpty?
        Center(child: CircularProgressIndicator(),):
         ListView.separated(
            itemBuilder: (context, index) {
               Contributor contributor = contributors[index];
              return ListTile(
                tileColor: AppColors.primaryColor,
                leading: CircleAvatar(
                  backgroundImage: contributor.image.isNotEmpty?FileImage(File(contributor.image)):null,
                  radius: 50,
                  backgroundColor: AppColors.backgroundColor,
                ),
                title: Text(contributor.name),
                subtitle: Text(contributor.phoneNumber),
                trailing: CircleAvatar(
                  backgroundColor: AppColors.secondaryColor,
                  radius: 15,
                ),
                onTap: () => Get.to(() => const ProfileScreen()),
              );
            },
            separatorBuilder: (context,index ) {
              return SizedBox(height: 5,);
            },
            itemCount: contributors.length));
  }
}
