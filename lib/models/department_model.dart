class Department {
  final int id;
  final String name;
  final String? description;
  final int? regionId;
  final int? surface;
  final int? population;
  final String? phonePrefix;
  final String? postalCode;
  final String? capital;
  final int? municipalities;
  final String? language;
  final String? currency;

  Department({
    required this.id,
    required this.name,
    this.description,
    this.regionId,
    this.surface,
    this.population,
    this.phonePrefix,
    this.postalCode,
    this.capital,
    this.municipalities,
    this.language,
    this.currency,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'],
    regionId: json['regionId'],
    surface: json['surface'] is int
        ? json['surface']
        : int.tryParse(json['surface']?.toString() ?? ''),
    population: json['population'],
    phonePrefix: json['phonePrefix']?.toString(),
    postalCode: json['cityCapital']?['postalCode']?.toString(),
    capital: json['cityCapital']?['name']?.toString(),
    municipalities: json['municipalities'],
    language: 'Español',
    currency: 'Peso colombiano (COP)',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'regionId': regionId,
    'surface': surface,
    'population': population,
    'phonePrefix': phonePrefix,
    'postalCode': postalCode,
    'capital': capital,
    'municipalities': municipalities,
  };
}