import 'package:flutter/material.dart';
import 'package:kuri_application/Utils/AppColor/appColors.dart';
import 'package:kuri_application/Models/user_model.dart';
import 'package:kuri_application/Models/draw_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primaryColor,
      ),
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
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.casino),
                label: Text('Draws'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Statistics'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSelectedView() {
    switch (_selectedIndex) {
      case 0:
        return _buildUsersView();
      case 1:
        return _buildDrawsView();
      case 2:
        return _buildStatisticsView();
      default:
        return const Center(child: Text('Unknown view'));
    }
  }

  Widget _buildUsersView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs.map((doc) {
          return UserModel.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
        }).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Text(user.name[0].toUpperCase()),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: ₹${user.totalContribution.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDeleteUser(user),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDrawsView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('draws')
          .orderBy('drawDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

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
              child: ExpansionTile(
                title: Text('Draw - ${draw.drawDate.toString().split(' ')[0]}'),
                subtitle: Text('Winner: ${draw.winnerName}'),
                trailing: Text(
                  '₹${draw.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${draw.isCompleted ? 'Completed' : 'Pending'}'),
                        const SizedBox(height: 8),
                        Text('Contributors: ${draw.contributors.length}'),
                        const SizedBox(height: 8),
                        const Text('Payment Status:'),
                        ...draw.paymentStatus.entries.map((entry) {
                          return ListTile(
                            title: FutureBuilder<DocumentSnapshot>(
                              future: _firestore.collection('users').doc(entry.key).get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return const Text('Loading...');
                                final userData = snapshot.data!.data() as Map<String, dynamic>;
                                return Text(userData['name'] as String);
                              },
                            ),
                            trailing: Icon(
                              entry.value ? Icons.check_circle : Icons.pending,
                              color: entry.value ? Colors.green : Colors.orange,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatisticsView() {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('users').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;
        final totalUsers = users.length;
        final totalContribution = users.fold<double>(
          0,
          (sum, user) => sum + ((user.data() as Map<String, dynamic>)['totalContribution'] as num).toDouble(),
        );

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard(
                'Total Users',
                totalUsers.toString(),
                Icons.people,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Total Contributions',
                '₹${totalContribution.toStringAsFixed(2)}',
                Icons.money,
                Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: _showCreateDrawDialog,
        child: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      );
    }
    return null;
  }

  Future<void> _showAddUserDialog() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUser = UserModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                email: emailController.text,
                phoneNumber: phoneController.text,
                joinedDate: DateTime.now(),
              );

              await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateDrawDialog() async {
    final amountController = TextEditingController(text: '5000');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Draw'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount per person'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create new draw with all current users
              final users = await _firestore.collection('users').get();
              final userIds = users.docs.map((doc) => doc.id).toList();
              
              final newDraw = DrawModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                drawDate: DateTime.now(),
                winnerId: '',  // Will be set when draw is conducted
                winnerName: '',
                amount: double.parse(amountController.text),
                contributors: userIds,
                responsiblePersonId: FirebaseAuth.instance.currentUser!.uid,
                paymentStatus: Map.fromIterable(
                  userIds,
                  value: (_) => false,
                ),
              );

              await _firestore.collection('draws').doc(newDraw.id).set(newDraw.toJson());
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteUser(UserModel user) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to remove ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection('users').doc(user.id).delete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
