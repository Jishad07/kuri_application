// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:kuri_application/Views/HomeScreen/homeScreen.dart';
// import 'package:kuri_application/Views/SettingsScreen/settingsScreen.dart';
// import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';
// import 'package:kuri_application/Views/ChatScreen/chat_screen.dart';
// import 'package:kuri_application/Utils/AppColor/appColors.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final PersistentTabController controller = PersistentTabController(initialIndex: 0);

//     // Screens that are associated with the bottom navigation tabs
//     List<Widget> _buildScreens() {
//       return [
//         const HomeScreen(),
//         const ChatScreen(),
//         const ProfileScreen(),
//         const SettingsScreen(),
//       ];
//     }

//     List<PersistentBottomNavBarItem> _navBarsItems() {
//       return [
//         PersistentBottomNavBarItem(
//           icon: const Icon(Icons.home),
//           title: "Home",
//           activeColorPrimary: AppColors.primaryColor,
//           inactiveColorPrimary: AppColors.textColorSecondary,
//         ),
//         PersistentBottomNavBarItem(
//           icon: const Icon(Icons.chat),
//           title: "Chat",
//           activeColorPrimary: AppColors.primaryColor,
//           inactiveColorPrimary: AppColors.textColorSecondary,
//         ),
//         PersistentBottomNavBarItem(
//           icon: const Icon(Icons.person),
//           title: "Profile",
//           activeColorPrimary: AppColors.primaryColor,
//           inactiveColorPrimary: AppColors.textColorSecondary,
//         ),
//         PersistentBottomNavBarItem(
//           icon: const Icon(Icons.settings),
//           title: "Settings",
//           activeColorPrimary: AppColors.primaryColor,
//           inactiveColorPrimary: AppColors.textColorSecondary,
//         ),
//       ];
//     }

//     return PersistentTabView(
//       context,
//       controller: controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       handleAndroidBackButtonPress: true,
//       resizeToAvoidBottomInset: true,
//       stateManagement: true,
//       hideNavigationBarWhenKeyboardAppears: true,
//       backgroundColor: AppColors.secondaryColor,
//       padding: const EdgeInsets.all(8),
//       isVisible: true,
//       animationSettings: const NavBarAnimationSettings(
//         navBarItemAnimation: ItemAnimationSettings(
//           duration: Duration(milliseconds: 400),
//           curve: Curves.ease,
//         ),
//         screenTransitionAnimation: ScreenTransitionAnimationSettings(
//           animateTabTransition: true,
//           duration: Duration(milliseconds: 200),
//           screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
//         ),
//       ),
//       confineToSafeArea: true,
//       navBarHeight: 70,
//       navBarStyle: NavBarStyle.style1,
//     );
//   }
// }
