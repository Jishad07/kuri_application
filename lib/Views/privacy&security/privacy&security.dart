import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';

class PoolSystemScreen extends StatelessWidget {
  final bool isAdmin = true; // This will be dynamic based on user role in a real app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Cash Pool'),
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Text
            Text(
              'How it works:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Every month, everyone contributes ₹5000, and one lucky winner gets the pooled amount through a draw. '
              'The admin manages the participants and initiates the draw process.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 30),

            // Admin only actions
            if (isAdmin) ...[
              Text(
                'Admin Actions:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle Add/Remove Participants
                  Get.toNamed('/manageParticipants'); // navigate to manage participants screen
                },
                child: Text('Add/Remove Participants'),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.blue,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Handle Draw action
                  Get.toNamed('/startDraw'); // navigate to start draw screen
                },
                child: Text('Start the Draw'),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.green,
                ),
              ),
            ],
            SizedBox(height: 30),

            // Participants can see the list of participants and the pool details
            Text(
              'Current Participants:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(height: 10),
            // List of participants (this could come from a database)
            Container(
              height: 200, // Adjust based on the number of participants
              child: ListView.builder(
                itemCount: 5, // Example: List of 5 participants
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Participant ${index + 1}'),
                    subtitle: Text('₹5000 contribution'),
                    leading: Icon(Icons.person, color: Colors.blue),
                    trailing: isAdmin
                        ? IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Handle participant removal
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            SizedBox(height: 30),

            // Draw Result Section (view-only for all users)
            Text(
              'Latest Draw Result:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Winner: Participant 3', // This will be dynamic
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
