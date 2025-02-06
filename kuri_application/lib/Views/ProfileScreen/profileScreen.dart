import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Views/SettingsScreen/settingsScreen.dart';

import '../privacy&security/privacy&security.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _name = "Jinas";
  final String _email = "jinasd@gmail.com";
  final String _bio = "member of draw";
  
  Widget _buildProfileHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.primaryColor,
                AppColors.primaryVariant,
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: AppColors.blackColor.withOpacity(0.1),
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.whiteColor,
              child: Icon(Icons.person, size: 60, color: AppColors.textColorSecondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Text(
            _name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColorPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _email,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColorSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _bio,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textColorSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget _buildStatsRow() {
  //   return 
  //   // Padding(
  //   //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //   //   child: Row(
  //   //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   //     children: [
  //   //       _buildStatItem("Posts", "28"),
  //   //       _buildStatItem("Followers", "1.2K"),
  //   //       _buildStatItem("Following", "184"),
  //   //     ],
  //   //   ),
  //   // );
  // }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColorPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textColorSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Edit Profile"),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Get.to(SettingsScreen());
              },
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOptions() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        _buildOptionTile(Icons.person_outline, "Personal Information"),
        _buildOptionTile(Icons.notifications_outlined, "Notifications"),
        _buildOptionTile(Icons.lock_outline, "Privacy & Security"),
        _buildOptionTile(Icons.help_outline, "Help & Support"),
        _buildOptionTile(Icons.logout, "Logout", isDestructive: true),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.errorColor : AppColors.textColorSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.errorColor : AppColors.textColorPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.to(PoolSystemScreen());
      },
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileInfo(),
            SizedBox(height: 20,),
            // _buildStatsRow(),
            _buildActionButtons(),
            const Divider(height: 30),
            _buildProfileOptions(),
          ],
        ),
      ),
    );
  }
}
