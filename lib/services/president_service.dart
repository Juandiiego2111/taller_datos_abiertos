import '../models/president_model.dart';
import 'api_service.dart';

class PresidentService {
  static Future<List<President>> getPresidents() async {
    final data = await ApiService.get('/President');
    return (data as List).map((e) => President.fromJson(e)).toList();
  }

  static Future<President> getPresidentById(int id) async {
    final data = await ApiService.get('/President/$id');
    return President.fromJson(data);
  }
}