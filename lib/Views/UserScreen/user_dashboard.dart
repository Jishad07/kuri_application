import 'package:flutter/material.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Models/user_model.dart';
import 'package:kuri_application/Models/draw_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<DocumentSnapshot> _userStream;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _userStream = _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                label: Text('History'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return _buildOverviewView();
      case 1:
        return _buildHistoryView();
      case 2:
        return _buildProfileView();
      default:
        return const Center(child: Text('Unknown view'));
    }
  }

  Widget _buildOverviewView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = UserModel.fromJson({
          'id': userSnapshot.data!.id,
          ...userSnapshot.data!.data() as Map<String, dynamic>,
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${userData.name}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Contribution: ₹${userData.totalContribution.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Current Draw Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('draws')
                    .orderBy('drawDate', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, drawSnapshot) {
                  if (!drawSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (drawSnapshot.data!.docs.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No active draw'),
                      ),
                    );
                  }

                  final currentDraw = DrawModel.fromJson({
                    'id': drawSnapshot.data!.docs.first.id,
                    ...drawSnapshot.data!.docs.first.data() as Map<String, dynamic>,
                  });

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Draw Date: ${currentDraw.drawDate.toString().split(' ')[0]}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Amount: ₹${currentDraw.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Status: ${currentDraw.isCompleted ? 'Completed' : 'In Progress'}',
                            style: TextStyle(
                              color: currentDraw.isCompleted
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          if (currentDraw.isCompleted) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Winner: ${currentDraw.winnerName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('draws')
          .orderBy('drawDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final draws = snapshot.data!.docs.map((doc) {
          return DrawModel.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
        }).toList();

        return ListView.builder(
          itemCount: draws.length,
          itemBuilder: (context, index) {
            final draw = draws[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text('Draw - ${draw.drawDate.toString().split(' ')[0]}'),
                subtitle: Text('Winner: ${draw.winnerName}'),
                trailing: Text(
                  '₹${draw.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProfileView() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final userData = UserModel.fromJson({
          'id': snapshot.data!.id,
          ...snapshot.data!.data() as Map<String, dynamic>,
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    userData.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileCard(
                'Personal Information',
                [
                  _buildProfileItem('Name', userData.name),
                  _buildProfileItem('Email', userData.email),
                  _buildProfileItem('Phone', userData.phoneNumber),
                  _buildProfileItem(
                    'Member Since',
                    userData.joinedDate.toString().split(' ')[0],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildProfileCard(
                'Contribution Details',
                [
                  _buildProfileItem(
                    'Total Contribution',
                    '₹${userData.totalContribution.toStringAsFixed(2)}',
                  ),
                  _buildProfileItem(
                    'Draws Participated',
                    userData.participatedDraws.length.toString(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
