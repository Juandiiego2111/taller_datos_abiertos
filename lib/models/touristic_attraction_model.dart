class TouristicAttraction {
  final int id;
  final String name;
  final String? description;
  final List<String>? images;
  final double? latitude;
  final double? longitude;
  final int? cityId;
  final Map<String, dynamic>? city;

  TouristicAttraction({
    required this.id,
    required this.name,
    this.description,
    this.images,
    this.latitude,
    this.longitude,
    this.cityId,
    this.city,
  });

  factory TouristicAttraction.fromJson(Map<String, dynamic> json) {
    // Parse images list
    List<String>? imagesList;
    if (json['images'] is List) {
      imagesList = (json['images'] as List)
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();
    }

    // Parse latitude/longitude
    double? lat;
    double? lng;
    if (json['latitude'] != null) {
      lat = double.tryParse(json['latitude'].toString());
    }
    if (json['longitude'] != null) {
      lng = double.tryParse(json['longitude'].toString());
    }

    // Parse city
    Map<String, dynamic>? cityMap;
    if (json['city'] is Map) {
      cityMap = Map<String, dynamic>.from(json['city']);
    }

    return TouristicAttraction(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description']?.toString(),
      images: imagesList,
      latitude: lat,
      longitude: lng,
      cityId: json['cityId'],
      city: cityMap,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'images': images,
    'latitude': latitude,
    'longitude': longitude,
    'cityId': cityId,
    'city': city,
  };

  // Helper getters
  String? get cityName => city?['name']?.toString();
  String? get departmentName => city?['department'] is Map
      ? city!['department']['name']?.toString()
      : city?['department']?.toString();
  int? get departmentId => city?['departmentId'];
}
