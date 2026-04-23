class NaturalArea {
  final int id;
  final String name;
  final String? description;
  final String? departmentName;

  NaturalArea({
    required this.id,
    required this.name,
    this.description,
    this.departmentName,
  });

  factory NaturalArea.fromJson(Map<String, dynamic> json) => NaturalArea(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'],
    departmentName: json['departmentName'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'departmentName': departmentName,
  };
}
