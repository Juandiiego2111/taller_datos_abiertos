import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/touristic_attraction_model.dart';

class TouristicAttractionService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  Future<List<TouristicAttraction>> getTouristicAttractions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/touristic-attractions'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TouristicAttraction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load touristic attractions');
    }
  }

  Future<TouristicAttraction> getTouristicAttractionById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/touristic-attractions/$id'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TouristicAttraction.fromJson(data);
    } else {
      throw Exception('Failed to load touristic attraction');
    }
  }
}
