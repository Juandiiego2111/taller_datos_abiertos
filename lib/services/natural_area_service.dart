import '../models/natural_area_model.dart';
import 'api_service.dart';

class NaturalAreaService {
  static Future<List<NaturalArea>> getNaturalAreas() async {
    final data = await ApiService.get('/NaturalArea');
    return (data as List).map((e) => NaturalArea.fromJson(e)).toList();
  }

  static Future<NaturalArea> getNaturalAreaById(int id) async {
    final data = await ApiService.get('/NaturalArea/$id');
    return NaturalArea.fromJson(data);
  }
}