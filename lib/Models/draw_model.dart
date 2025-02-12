class DrawModel {
  final String id;
  final DateTime drawDate;
  final String winnerId;
  final String winnerName;
  final double amount;
  final List<String> contributors;
  final String responsiblePersonId;
  final bool isCompleted;
  final Map<String, bool> paymentStatus;

  DrawModel({
    required this.id,
    required this.drawDate,
    required this.winnerId,
    required this.winnerName,
    required this.amount,
    required this.contributors,
    required this.responsiblePersonId,
    this.isCompleted = false,
    required this.paymentStatus,
  });

  factory DrawModel.fromJson(Map<String, dynamic> json) {
    return DrawModel(
      id: json['id'] as String,
      drawDate: DateTime.parse(json['drawDate'] as String),
      winnerId: json['winnerId'] as String,
      winnerName: json['winnerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      contributors: List<String>.from(json['contributors'] as List),
      responsiblePersonId: json['responsiblePersonId'] as String,
      isCompleted: json['isCompleted'] as bool,
      paymentStatus: Map<String, bool>.from(json['paymentStatus'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drawDate': drawDate.toIso8601String(),
      'winnerId': winnerId,
      'winnerName': winnerName,
      'amount': amount,
      'contributors': contributors,
      'responsiblePersonId': responsiblePersonId,
      'isCompleted': isCompleted,
      'paymentStatus': paymentStatus,
    };
  }

  DrawModel copyWith({
    String? id,
    DateTime? drawDate,
    String? winnerId,
    String? winnerName,
    double? amount,
    List<String>? contributors,
    String? responsiblePersonId,
    bool? isCompleted,
    Map<String, bool>? paymentStatus,
  }) {
    return DrawModel(
      id: id ?? this.id,
      drawDate: drawDate ?? this.drawDate,
      winnerId: winnerId ?? this.winnerId,
      winnerName: winnerName ?? this.winnerName,
      amount: amount ?? this.amount,
      contributors: contributors ?? this.contributors,
      responsiblePersonId: responsiblePersonId ?? this.responsiblePersonId,
      isCompleted: isCompleted ?? this.isCompleted,
      paymentStatus: paymentStatus ?? this.paymentStatus,
    );
  }
}
