class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final double totalContribution;
  final List<String> participatedDraws;
  final bool isAdmin;
  final DateTime joinedDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.totalContribution = 0.0,
    this.participatedDraws = const [],
    this.isAdmin = false,
    required this.joinedDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      totalContribution: (json['totalContribution'] as num).toDouble(),
      participatedDraws: List<String>.from(json['participatedDraws'] as List),
      isAdmin: json['isAdmin'] as bool,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'totalContribution': totalContribution,
      'participatedDraws': participatedDraws,
      'isAdmin': isAdmin,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    double? totalContribution,
    List<String>? participatedDraws,
    bool? isAdmin,
    DateTime? joinedDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalContribution: totalContribution ?? this.totalContribution,
      participatedDraws: participatedDraws ?? this.participatedDraws,
      isAdmin: isAdmin ?? this.isAdmin,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
