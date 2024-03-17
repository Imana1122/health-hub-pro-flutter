class Exercise {
  final int id;
  final String name;
  final String slug;
  final int metabolicEquivalent;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  Exercise({
    required this.id,
    required this.name,
    required this.slug,
    required this.metabolicEquivalent,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      metabolicEquivalent: json['metabolic_equivalent'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'metabolic_equivalent': metabolicEquivalent,
      'description': description,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
