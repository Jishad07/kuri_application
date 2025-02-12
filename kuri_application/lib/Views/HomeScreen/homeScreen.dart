import 'dart:ffi';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Helpers/database_helper.dart';
import 'package:kuri_application/Models/Contributor.dart';
import 'package:kuri_application/Models/chat_message_model.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Utils/Text_Styles/text_style.dart';
import 'package:kuri_application/Utils/images/images.dart';
import 'package:kuri_application/Views/ChatScreen/chat_screen.dart';
import 'package:kuri_application/Views/HistoryScreen/historyScreen.dart';
import 'package:kuri_application/Views/ProfileScreen/profileScreen.dart';
import 'package:kuri_application/Views/SettingsScreen/settingsScreen.dart';
import 'package:kuri_application/Views/users/users.dart';

class NextDrawTimer extends StatefulWidget {
  const NextDrawTimer({super.key});
  
  Map<String, int> timeUnits(BuildContext context) {
    final state = context.findAncestorStateOfType<_NextDrawTimerState>();
    return state?._timeUnits ?? {'seconds': 0, 'minutes': 0, 'days': 0, 'weeks': 0};
  }

  @override
  State<NextDrawTimer> createState() => _NextDrawTimerState();
}

class _NextDrawTimerState extends State<NextDrawTimer> {
  Timer? _timer;
  Timer? _randomNumberTimer;
  Map<String, int> _timeUnits = {
    'weeks': 0,
    'days': 0,
    'minutes': 0,
    'seconds': 0
  };
 int _randomNumber = 0;
  bool _showRandomNumber = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _updateRemainingTime(); // Initial update
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();

      if(_timeUnits['seconds']==0){
         _startRandomNumberGeneration();
      }
    });
  }

    void _startRandomNumberGeneration() {
    setState(() {
      _showRandomNumber = true;
    });

    _randomNumberTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _randomNumber = _generateRandomNumber();
      });

      if (timer.tick >= 10) {
        timer.cancel();
      }
    });
  }

  int _generateRandomNumber() {
    return Random().nextInt(10) + 1; // Generates a number between 1 and 10
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    DateTime nextDraw;
    
    // Calculate next draw date (27th of current or next month at 19:00/7:00 PM)
    if (now.day < 11 || (now.day == 11 && now.hour < 19)) {
      // Next draw is on the 27th of current month at 7:00 PM
      nextDraw = DateTime(now.year, now.month, 11, 19, 0);
    } else {
      // Next draw is on the 27th of next month at 7:00 PM
      nextDraw = DateTime(now.year, now.month + 1, 11, 19, 0);
    }

    final difference = nextDraw.difference(now);
    
    setState(() {
      _timeUnits = {
        'weeks': difference.inDays ~/ 7,
        'days': difference.inDays % 7,
        'hours':difference.inHours.remainder(60),
        'minutes': difference.inMinutes.remainder(60) + (difference.inHours.remainder(24) * 60),
        'seconds': difference.inSeconds.remainder(60)
      };
    });
  }
   Map<String, int> get timeUnits => _timeUnits;

  String _getDisplayValue() {
    if (_timeUnits['weeks']! > 0) {
      return _timeUnits['weeks']!.toString();
    } else if (_timeUnits['days']! > 0) {
      return _timeUnits['days']!.toString();
    } else if(_timeUnits['hours']!>0){
   return _timeUnits['hours']!.toString();
    }
    else if (_timeUnits['minutes']! > 0) {
      return _timeUnits['minutes']!.toString();
    } else {
      return _timeUnits['seconds']!.toString();
    }
  }

  String _getDisplayUnit() {
    if (_timeUnits['weeks']! > 0) {
      return '${_timeUnits['weeks'] == 1 ? 'Week' : 'Weeks'} remaining';
    } else if (_timeUnits['days']! > 0) {
      return '${_timeUnits['days'] == 1 ? 'Day' : 'Days'} remaining';
    } else if(_timeUnits['hours']!>0){
     return '${_timeUnits["hour"]==1?"Hour":"Hours"} remaining';
    }
    else if (_timeUnits['minutes']! > 0) {
      return '${_timeUnits['minutes'] == 1 ? 'Minute' : 'Minutes'} remaining';
    } else {
      return '${_timeUnits['seconds'] == 1 ? 'Second' : 'Seconds'} remaining';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Next Draw",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _getDisplayValue(),
              style: GoogleFonts.poppins(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getDisplayUnit(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.timer,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
 
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final DatabaseHelper dbHelper = DatabaseHelper.instance;
      List<Contributor> contributors = [];
      bool isLoading = true;

   


  @override
  void initState() {
      _fetchContributors();
     
    // TODO: implement initState
    super.initState();
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
  @override
  void dispose() {
   
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: _buildDrawer(context),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Image.asset(
              Images.moreIcon,
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        title: Text(
          'Kuri',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.secondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.backgroundColor,
                    AppColors.backgroundColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child:NextDrawTimer().timeUnits(context)['seconds']==0?
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlayInterval: Duration(milliseconds:500 ),
                        autoPlay: true,
                        height: 250.0,
                        viewportFraction: 1.0 ,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                      ),
                      items: contributors.map((contributor) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(contributor.image),
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                bottom: 50 ,
                                left: 50 ,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    contributor.id.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
             ):
              contributors.isNotEmpty?
               Column(
                children: [
               
                  Row(
                    children: [
                      Hero(
                        tag: 'winner_photo',
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.file(File(contributors[0].image))
                            // Image.asset(
                            //   Images.winnerphoto1,
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child:

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              children: [
                                Image.asset(
                                  Images.trophy,
                                  height:MediaQuery.of(context).size.height *0.05 ,
                                  width: MediaQuery.of(context).size.width *0.03 ,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Current Winner",
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              // "Jishad.A",
                              contributors[1].name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ):null
             ),
             Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const NextDrawTimer(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Overview",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "This app is designed for managing a cash collection system among a group of people. "
                        "Each month, one person collects a fixed amount from others and then randomly "
                        "distributes it to one of the participants.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Current Month Stats",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildStatItem(Icons.account_balance_wallet, "Total Collected", "₹50,000"),
                      _buildStatItem(Icons.people, "Contributors", "10"),
                      _buildStatItem(Icons.calendar_today, "Next Draw Date", "JAN 15"),
                      _buildStatItem(Icons.person, "Responsible Person", "Jishad"),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Previous Winners",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "View All",
                      style: GoogleFonts.poppins(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: contributors.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 8,
                      right: index == 9 ? 16 : 8,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.secondaryColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.file(File(contributors[index].image))
                            // Image.asset(
                            //   "assets/images/bavu.JPG",
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Winner ${index + 1}",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(),
          const SizedBox(height: 8),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Profile',
            onTap: () => Get.to(() => const ProfileScreen()),
          ),
          _buildDrawerItem(
            icon: Icons.history,
            title: 'History',
            onTap: () => Get.to(() => DrawHistoryPage()),
          ),
            _buildDrawerItem(
            icon: Icons.notification_important_outlined,
            title: 'Notifications',
            onTap: () {
             Get.to(()=>SettingsScreen());
            },
          ),
                _buildDrawerItem(
            icon: Icons.chat_bubble_outline_outlined,
            title: 'Chat',
            onTap: () {
             Get.to(()=>ChatScreen());
            },
          ),
              _buildDrawerItem(
            icon: Icons.person_search,
            title: 'Users',
            onTap: () {
             Get.to(()=>UsersScreen());
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
             Get.to(()=>SettingsScreen());
            },
          ),
          
          const Spacer(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
              Get.back();
              // Add your logout logic here
            },
            isDestructive: true,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              image: DecorationImage(
                image: AssetImage(Images.winnerPhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'John Doe',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'john.doe@example.com',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Premium Member',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppColors.secondaryColor,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: isDestructive ? Colors.red : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.secondaryColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
