class Department {
  final int id;
  final String name;
  final String? description;
  final int? regionId;
  final String? surface;
  final int? population;
  final String? phonePrefix;
  final String? postalCode;
  final String? capital;
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
    this.language,
    this.currency,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'],
    regionId: json['regionId'],
    surface: json['surface']?.toString(),
    population: json['population'],
    phonePrefix: json['phonePrefix'],
    postalCode: json['postalCode'],
    capital: json['cities'] != null && (json['cities'] as List).isNotEmpty
        ? (json['cities'][0]['name'] as String?)?.toString()
        : null,
    language: 'Español',
    currency: 'Peso colombiano (COP)',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };
}
