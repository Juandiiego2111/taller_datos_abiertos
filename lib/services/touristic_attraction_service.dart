import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/touristic_attraction_model.dart';

class TouristicAttractionService {
  static const String _base = 'https://api-colombia.com/api/v1';

  static Future<List<TouristicAttraction>> getTouristicAttractions() async {
    final response = await http
        .get(Uri.parse('$_base/TouristicAttraction'),
            headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => TouristicAttraction.fromJson(e)).toList();
    }
    throw Exception('Failed to load touristic attractions: ${response.statusCode}');
  }

  static Future<TouristicAttraction> getTouristicAttractionById(int id) async {
    final response = await http
        .get(Uri.parse('$_base/TouristicAttraction/$id'),
            headers: {'Accept': 'application/json'})
        .timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      return TouristicAttraction.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load attraction: ${response.statusCode}');
  }
}
