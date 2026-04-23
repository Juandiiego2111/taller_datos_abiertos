import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';

class DepartmentService {
  final String baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://api-colombia.com/api/v1';

  Future<List<Department>> getDepartments() async {
    final response = await http.get(Uri.parse('$baseUrl/departments'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Department.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load departments');
    }
  }

  Future<Department> getDepartmentById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/departments/$id'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Department.fromJson(data);
    } else {
      throw Exception('Failed to load department');
    }
  }
}
