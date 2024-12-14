import 'package:cloud_firestore/cloud_firestore.dart'; // For Timestamp

class Message {
  final String sendBy;
  final int price;
  final String description;
  final String sId;
  final Timestamp daysToWork; // Using Timestamp from Firestore
  final String msgType;
  final String status;
  final String serviceName;
  final String? messageId; // This can be null initially
  final DateTime createdAt;

  // Constructor
  Message({
    required this.sendBy,
    required this.price,
    required this.description,
    required this.sId,
    required this.daysToWork,
    required this.msgType,
    required this.status,
    required this.serviceName,
    this.messageId,
    required this.createdAt,
  });

  // From JSON (Map) to Model (for Firebase document)
  factory Message.fromMap(Map<String, dynamic> map) {
    // Correctly convert Timestamp to DateTime
    return Message(
      sendBy: map['sendBy'],
      price: map['price'],
      description: map['description'],
      sId: map['sId'],
      daysToWork: map['daysToWork'], // Keep as Timestamp
      msgType: map['msgType'],
      status: map['status'],
      serviceName: map['service_name'],
      messageId: map['messageId'],
      // Convert Timestamp to DateTime
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // To JSON (Map) from Model (for Firebase upload)
  Map<String, dynamic> toMap() {
    return {
      'sendBy': sendBy,
      'price': price,
      'description': description,
      'sId': sId,
      'daysToWork': daysToWork,
      'msgType': msgType,
      'status': status,
      'service_name': serviceName,
      'messageId': messageId,
      'createdAt': createdAt,
    };
  }
}
