import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuri_application/Models/contributors_model.dart';

class ContributorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ContributorModel>> fetchContributors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('contributors').get();
      
      return querySnapshot.docs.map((doc) {
        return ContributorModel.fromFirestore(
          doc.data() as Map<String, dynamic>
        );
      }).toList();
    } catch (e) {
      print('Error fetching contributors: $e');
      return [];
    }
  }

  // Optional: Add method to add a new contributor
  Future<void> addContributor(ContributorModel contributor) async {
    try {
      await _firestore.collection('contributors').add(contributor.toFirestore());
    } catch (e) {
      print('Error adding contributor: $e');
    }
  }
}