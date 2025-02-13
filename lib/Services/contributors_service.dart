import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuri_application/Models/contributors_model.dart';

class ContributorsService {
  static final ContributorsService _instance = ContributorsService._internal();
  factory ContributorsService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ContributorsService._internal();

  Future<List<ContributorModel>> fetchContributors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('contributors').get();
      return querySnapshot.docs.map((doc) {
        return ContributorModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching contributors: $e');
      return [];
    }
  }

//   Future<void> addContributor(ContributorModel contributor) async {
//   try {
//     // Add contributor data to Firestore
//     await _firestore.collection('contributors').add(contributor.toMap());
//     print('Contributor added successfully');
//   } catch (e) {
//     print('Error adding contributor: $e');
//   }
// }
}