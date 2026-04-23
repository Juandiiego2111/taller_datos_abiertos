import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/department_model.dart';

class DepartmentService {
  static Future<List<Department>> getDepartments() async {
    try {
      final url = Uri.parse('https://api-colombia.com/api/v1/Department');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load departments: $e');
    }
  }

  static Future<Department> getDepartmentById(int id) async {
    try {
      final url = Uri.parse('https://api-colombia.com/api/v1/Department/$id');
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Department.fromJson(data);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load department: $e');
    }
  }
}
