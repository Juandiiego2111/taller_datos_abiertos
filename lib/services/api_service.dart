import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});
  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

class ApiService {
  static final String _baseUrl = Environment.baseUrl;

  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw ApiException('Recurso no encontrado', statusCode: 404);
      } else if (response.statusCode >= 500) {
        throw ApiException(
          'Error del servidor',
          statusCode: response.statusCode,
        );
      } else {
        throw ApiException('Error inesperado', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión: ${e.toString()}');
    }
  }
}
