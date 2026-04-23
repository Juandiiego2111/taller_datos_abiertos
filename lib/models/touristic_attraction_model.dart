class TouristicAttraction {
  final int id;
  final String name;
  final String? description;
  final String? city;

  TouristicAttraction({
    required this.id,
    required this.name,
    this.description,
    this.city,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) =>
      TouristicAttraction(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        description: json['description'],
        city: json['city'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'city': city,
  };
}
