class MealType {
  final String id;
  final String name;
  final String slug;
  final String image;
  final int status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int recipesCount; // New field to store the count of recipes

  MealType({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.recipesCount, // Include in the constructor
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      recipesCount: json['recipes_count'] ?? 0, // Assign the value
    );
  }
}
