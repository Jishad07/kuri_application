class ContributorModel {
  final String id;
  final String name;
  final String image;
  final String phoneNumber;
  final String role;

  ContributorModel({
    required this.id,
    required this.name,
    required this.image,
    required this.phoneNumber,
    required this.role
  });

  // From Firestore
  factory ContributorModel.fromFirestore(Map<String, dynamic> firestore) {
    return ContributorModel(
      id: firestore['id'] ?? '',
      name: firestore['name'] ?? '',
      image: firestore['image'] ?? '',
      phoneNumber: firestore['phoneNumber'] ?? '',
      role: firestore['drawRoleNumber']??"",
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'role': phoneNumber,
    };
  }
}