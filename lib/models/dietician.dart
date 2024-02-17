class Dietician {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String cv;
  String image;
  String speciality;
  String description;
  String esewaId;
  double bookingAmount;
  String bio;
  int availabilityStatus;
  int approvedStatus;
  int status;
  String token;

  Dietician({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.cv,
    required this.image,
    required this.speciality,
    required this.description,
    required this.esewaId,
    required this.bookingAmount,
    required this.bio,
    required this.availabilityStatus,
    required this.approvedStatus,
    required this.token,
    required this.status,
  });

  // Add a factory method to convert a map to Dietician object
  factory Dietician.fromJson(Map<String, dynamic> json) {
    return Dietician(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      cv: json['cv'],
      image: json['image'],
      speciality: json['speciality'],
      description: json['description'],
      esewaId: json['esewa_id'],
      bookingAmount:
          json['booking_amount'].toDouble(), // Changed from int to double
      bio: json['bio'],
      availabilityStatus: json['availability_status'],
      approvedStatus: json['approved_status'],
      token: json['token'] ?? '',
      status: json['status'],
    );
  }
  // Named constructor with default values
  Dietician.empty()
      : id = '',
        email = '',
        firstName = '',
        lastName = '',
        phoneNumber = '',
        cv = '',
        image = '',
        speciality = '',
        description = '',
        esewaId = '',
        bookingAmount = 0,
        bio = '',
        availabilityStatus = 0,
        approvedStatus = 0,
        status = 0,
        token = '';
}

class Pivot {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String cv;
  String image;
  String speciality;
  String description;
  String esewaId;
  double bookingAmount;
  String bio;
  int availabilityStatus;
  int approvedStatus;
  int status;
  String token;

  Pivot({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.cv,
    required this.image,
    required this.speciality,
    required this.description,
    required this.esewaId,
    required this.bookingAmount,
    required this.bio,
    required this.availabilityStatus,
    required this.approvedStatus,
    required this.token,
    required this.status,
  });

  // Add a factory method to convert a map to Pivot object
  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      cv: json['cv'],
      image: json['image'],
      speciality: json['speciality'],
      description: json['description'],
      esewaId: json['esewa_id'],
      bookingAmount: json['booking_amount'],
      bio: json['bio'],
      availabilityStatus: json['availability_status'],
      approvedStatus: json['approved_status'],
      token: json['token'],
      status: json['status'],
    );
  }
}
