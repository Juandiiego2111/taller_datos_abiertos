class President {
  final int id;
  final String name;
  final String lastName;
  final String? description;
  final String? politicalParty;
  final String? startPeriodDate;
  final String? endPeriodDate;

  President({
    required this.id,
    required this.name,
    required this.lastName,
    this.description,
    this.politicalParty,
    this.startPeriodDate,
    this.endPeriodDate,
  });

  factory President.fromJson(Map<String, dynamic> json) => President(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    lastName: json['lastName'] ?? '',
    description: json['description'],
    politicalParty: json['politicalParty'],
    startPeriodDate: json['startPeriodDate'],
    endPeriodDate: json['endPeriodDate'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lastName': lastName,
    'description': description,
    'politicalParty': politicalParty,
    'startPeriodDate': startPeriodDate,
    'endPeriodDate': endPeriodDate,
  };
}
