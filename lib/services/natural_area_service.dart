import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/natural_area_model.dart';

class NaturalAreaService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  Future<List<NaturalArea>> getNaturalAreas() async {
    final response = await http.get(Uri.parse('$baseUrl/natural-areas'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => NaturalArea.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load natural areas');
    }
  }

  Future<NaturalArea> getNaturalAreaById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/natural-areas/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return NaturalArea.fromJson(data);
    } else {
      throw Exception('Failed to load natural area');
    }
  }
}
