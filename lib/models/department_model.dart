class Department {
  final int id;
  final String name;
  final String description;
  final double? superficie;
  final int? population;
  final String? capital;

  Department({
    required this.id,
    required this.name,
    required this.description,
    this.superficie,
    this.population,
    this.capital,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    superficie: json['superficie'] != null
        ? (json['superficie'] as num).toDouble()
        : null,
    population: json['population'],
    capital: json['capital'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'superficie': superficie,
    'population': population,
    'capital': capital,
  };
}
