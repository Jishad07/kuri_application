import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
     List<String> names = [
      'Jishad',
      'Nimesh',
      'Bashid',
      'Akhil',
      'Achu',
      'Appu',
      'Hafeef',
      'Zakariya',
      'Roopesh',
      'Suni',
    ];

    List<String> phoneNumbers = [
      '9847298705',
      '9847298706',
      '9847298707',
      '9847298708',
      '9847298709',
      '9847298710',
      '9847298711',
      '9847298712',
      '9847298713',
      '9847298714',
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text('Users Screen'),
          centerTitle: true,
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                tileColor: AppColors.primaryColor,
                leading: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.backgroundColor,
                ),
                title: Text(names[index]),
                subtitle: Text(phoneNumbers[index]),
                trailing: CircleAvatar(
                  radius: 15,
                ),
                onTap: () => Get.to(() => const ProfileScreen()),
              );
            },
            separatorBuilder: (context,index ) {
              return SizedBox(height: 5,);
            },
            itemCount: 10));
  }
}
