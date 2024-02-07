class WeightPlan {
  String id;
  String title;
  String slug;

  WeightPlan({
    required this.id,
    required this.title,
    required this.slug,
  });

  // Named constructor for creating an instance from JSON
  WeightPlan.fromJson(Map<String, dynamic> json)
      : id = json['id'] ??
            '', // Assuming 'id' is a String, use an empty string as default
        title = json['title'] ??
            '', // Assuming 'title' is a String, use an empty string as default
        slug = json['slug'] ??
            ''; // Assuming 'slug' is a String, use an empty string as default

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
    };
  }
}
