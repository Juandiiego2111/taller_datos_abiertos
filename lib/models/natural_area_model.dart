class NaturalArea {
  final int id;
  final String name;
  final String? description;
  final int? areaGroupId;
  final int? categoryNaturalAreaId;
  final int? departmentId;
  final int? daneCode;
  final double? landArea;
  final double? maritimeArea;
  final Map<String, dynamic>? department;
  final Map<String, dynamic>? categoryNaturalArea;

  NaturalArea({
    required this.id,
    required this.name,
    this.description,
    this.areaGroupId,
    this.categoryNaturalAreaId,
    this.departmentId,
    this.daneCode,
    this.landArea,
    this.maritimeArea,
    this.department,
    this.categoryNaturalArea,
  });

  factory NaturalArea.fromJson(Map<String, dynamic> json) => NaturalArea(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    description: json['description'],
    areaGroupId: json['areaGroupId'],
    categoryNaturalAreaId: json['categoryNaturalAreaId'],
    departmentId: json['departmentId'],
    daneCode: json['daneCode'],
    landArea: json['landArea'] is double
        ? json['landArea']
        : double.tryParse(json['landArea']?.toString() ?? ''),
    maritimeArea: json['maritimeArea'] is double
        ? json['maritimeArea']
        : json['maritimeArea'] != null
        ? double.tryParse(json['maritimeArea']?.toString() ?? '')
        : null,
    department: json['department'] != null
        ? Map<String, dynamic>.from(json['department'])
        : null,
    categoryNaturalArea: json['categoryNaturalArea'] != null
        ? Map<String, dynamic>.from(json['categoryNaturalArea'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'areaGroupId': areaGroupId,
    'categoryNaturalAreaId': categoryNaturalAreaId,
    'departmentId': departmentId,
    'daneCode': daneCode,
    'landArea': landArea,
    'maritimeArea': maritimeArea,
    'department': department,
    'categoryNaturalArea': categoryNaturalArea,
  };
}
