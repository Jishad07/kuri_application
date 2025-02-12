class Contributor {
  int? id;           // ID field for the contributor
  String name;       // Contributor's name
  String phoneNumber; // Contributor's phone number
  String email;      // Contributor's email
  String image;      // Image file path (or base64 string)

  Contributor({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.image,
  });

  // Convert a Contributor into a Map (for SQL insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'image': image,
    };
  }

  // Convert a Map into a Contributor (for SQL retrieval)
  factory Contributor.fromMap(Map<String, dynamic> map) {
    return Contributor(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      image: map['image'],
    );
  }
}
