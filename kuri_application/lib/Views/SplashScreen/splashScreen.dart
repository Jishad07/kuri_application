import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/CommonWidgets/bottom_nav_bar.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Views/Create_Contributor_Screen/create_contributor_Screen.dart';
import 'package:kuri_application/Views/HomeScreen/homeScreen.dart';
import 'package:kuri_application/Views/WalkthroghScreen/walkthroug_first_screen.dart';
import 'package:kuri_application/Views/WalkthroghScreen/walkthrough-last_screen.dart';
import 'package:lottie/lottie.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
     Get.off(()=>WalkTroughFirstScreen() );
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Lottie.asset("assets/animations/animation_spalsh.json")
        ),
      ),
    );
  }
}