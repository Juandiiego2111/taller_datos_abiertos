class TouristicAttraction {
  final int id;
  final String name;
  final String? description;
  final String? city;
  final String? department;

  TouristicAttraction({
    required this.id,
    required this.name,
    this.description,
    this.city,
    this.department,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    String? cityName;
    String? deptName;

    if (json['city'] is Map) {
      cityName = json['city']['name']?.toString();
    } else {
      cityName = json['city']?.toString();
    }

    if (json['department'] is Map) {
      deptName = json['department']['name']?.toString();
    } else {
      deptName = json['department']?.toString();
    }

    return TouristicAttraction(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description']?.toString(),
      city: cityName,
      department: deptName,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'city': city,
    'department': department,
  };
}
