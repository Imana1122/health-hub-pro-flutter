import 'package:fyp_flutter/models/chat_message.dart';

class DieticianChatModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String image;
  final String cv;
  final String speciality;
  final String bio;
  final String description;
  final String esewaClientId;
  final String esewaSecretKey;

  final int bookingAmount;
  final int status;
  final int approvedStatus;
  final int availabilityStatus;
  final String createdAt;
  final String updatedAt;
  final String otherUserId;

  final List<ChatMessage> messages;

  DieticianChatModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.image,
    required this.cv,
    required this.speciality,
    required this.bio,
    required this.description,
    required this.esewaClientId,
    required this.esewaSecretKey,
    required this.bookingAmount,
    required this.status,
    required this.approvedStatus,
    required this.availabilityStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.otherUserId,
    required this.messages,
  });
  // Named constructor with default values
  const DieticianChatModel.empty()
      : id = '',
        firstName = '',
        lastName = '',
        email = '',
        phoneNumber = '',
        image = '',
        cv = '',
        speciality = '',
        bio = '',
        description = '',
        esewaClientId = '',
        esewaSecretKey = '',
        bookingAmount = 0,
        status = 0,
        approvedStatus = 0,
        availabilityStatus = 0,
        createdAt = '',
        updatedAt = '',
        otherUserId = '',
        messages = const [];

  factory DieticianChatModel.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messageList = [];
    if (json['messages'] != null) {
      messageList = List<ChatMessage>.from(
          json['messages'].map((message) => ChatMessage.fromJson(message)));
    }
    return DieticianChatModel(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      image: json['image'],
      cv: json['cv'],
      speciality: json['speciality'],
      bio: json['bio'],
      description: json['description'],
      esewaClientId: json['esewa_client_id'],
      esewaSecretKey: json['esewa_secret_key'],
      bookingAmount: int.parse(json['booking_amount']),
      status: json['status'],
      approvedStatus: json['approved_status'],
      availabilityStatus: json['availability_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otherUserId: json['otherUserId'],
      messages: messageList,
    );
  }
}
