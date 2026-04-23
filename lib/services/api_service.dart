import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  Future<List<dynamic>> getDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<List<dynamic>> getPresidents() async {
    final response = await http.get(Uri.parse('$baseUrl/presidents'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load presidents');
    }
  }

  Future<List<dynamic>> getNaturalAreas() async {
    final response = await http.get(Uri.parse('$baseUrl/natural-areas'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load natural areas');
    }
  }

  Future<List<dynamic>> getTouristicAttractions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/touristic-attractions'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load touristic attractions');
    }
  }
}
