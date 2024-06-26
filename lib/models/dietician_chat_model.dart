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
  final String esewaId;

  final int bookingAmount;
  final int status;
  final int approvedStatus;
  final int availabilityStatus;
  final String createdAt;
  final String updatedAt;
  final String otherUserId;
  final List<ChatMessage> messages;
  int currentMessagePage;

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
    required this.esewaId,
    required this.bookingAmount,
    required this.status,
    required this.approvedStatus,
    required this.availabilityStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.otherUserId,
    required this.messages,
    required this.currentMessagePage,
  });
  // Named constructor with default values
  DieticianChatModel.empty()
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
        esewaId = '',
        bookingAmount = 0,
        status = 0,
        approvedStatus = 0,
        availabilityStatus = 0,
        createdAt = '',
        updatedAt = '',
        otherUserId = '',
        currentMessagePage = 0,
        messages = const [];

  factory DieticianChatModel.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messageList = [];
    if (json['messages'] != null && json['messages']['data'] != null) {
      messageList = List<ChatMessage>.from(json['messages']['data']
          .map((message) => ChatMessage.fromJson(message)));
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
      esewaId: json['esewa_id'],
      bookingAmount: int.parse(json['booking_amount']),
      status: json['status'],
      approvedStatus: json['approved_status'],
      availabilityStatus: json['availability_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otherUserId: json['otherUserId'],
      currentMessagePage: json['messages']['current_page'],
      messages: messageList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'image': image,
      'cv': cv,
      'speciality': speciality,
      'bio': bio,
      'description': description,
      'esewa_id': esewaId,
      'booking_amount': bookingAmount,
      'status': status,
      'approved_status': approvedStatus,
      'availability_status': availabilityStatus,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
