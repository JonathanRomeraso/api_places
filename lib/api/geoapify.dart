import 'package:api_places/models/category_model.dart';
import 'package:api_places/utils/key.dart';
import 'package:dio/dio.dart';

class PopularApi {
  final dio = Dio();

  Future<List<CategoryModel>?> getHttpPopular() async {
    Response response = await dio.get(
        'https://api.geoapify.com/v2/places?categories=healthcare&filter=circle:-100.8189334,20.5430982,5000&limit=100&apiKey=$apiKeyGeofy');
    if (response.statusCode == 200) {
      final res = response.data['features'] as List;
      return res.map((movie) => CategoryModel.fromMap(movie)).toList();
    } else {
      throw Exception(
          'Failed to load cast: Status code ${response.statusCode}');
    }
  }

  Future<List<CategoryModel>?> getGeoApify(String cateogrie,
      {double lat = -100.8189334, double long = 20.5430982}) async {
    Response response = await dio.get(
      'https://api.geoapify.com/v2/places?categories=$cateogrie&filter=circle:$lat,$long,5000&limit=100&apiKey=$apiKeyGeofy',
    );
    if (response.statusCode == 200) {
      final res = response.data['features'] as List;
      return res.map((movie) => CategoryModel.fromMap(movie)).toList();
    } else {
      throw Exception(
          'Failed to load cast: Status code ${response.statusCode}');
    }
  }
}
