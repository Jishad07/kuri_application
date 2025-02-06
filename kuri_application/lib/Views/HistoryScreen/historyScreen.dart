import 'package:flutter/material.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';

class DrawHistoryPage extends StatelessWidget {
  DrawHistoryPage({Key? key}) : super(key: key);

  String drawdetails = '';
  List<String> drawHistories = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'May',
    'June',
    'July',
    'Augest',
    'September',
    'October',
    'November',
    'December'
  ];
  // Sample data for demonstration

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Draw History'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.2,
          ),
          itemCount: drawHistories.length,
          itemBuilder: (context, index) {
            bool isEvenRow = (index ~/ 2) % 2 == 0;
            bool isEvenColumn = index % 2 == 0;
            Color cardColor = (isEvenRow && isEvenColumn) || (!isEvenRow && !isEvenColumn)
                ? AppColors.primaryColor
                : Colors.white;

            return Card(
              color: cardColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: () {
                  // Add tap functionality here
                },
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.calendar_today, size: 40, color: AppColors.secondaryColor),
                      SizedBox(height: 10),
                      Text(
                        drawHistories[index],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Upcoming',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
