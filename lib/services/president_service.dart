import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/president_model.dart';

class PresidentService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  Future<List<President>> getPresidents() async {
    final response = await http.get(Uri.parse('$baseUrl/presidents'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => President.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load presidents');
    }
  }

  Future<President> getPresidentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/presidents/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return President.fromJson(data);
    } else {
      throw Exception('Failed to load president');
    }
  }
}
