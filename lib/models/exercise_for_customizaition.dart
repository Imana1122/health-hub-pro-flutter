class ExerciseForCustomization {
  final int id;
  final String name;

  ExerciseForCustomization({
    required this.id,
    required this.name,
  });

  factory ExerciseForCustomization.fromJson(Map<String, dynamic> json) {
    return ExerciseForCustomization(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
