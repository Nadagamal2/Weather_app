import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/weather_home_model.dart';
import '../utils/constance.dart';

class WeatherSevices{
  Future<WeatherHomeModel?> getWeatherData(String cityName,String units) async {
    final response = await http.get(Uri.parse(
        '${AppConstance.baseUrl}/weather?q=$cityName&units=${units}&appid=${AppConstance.appKey}'));
    var data = jsonDecode(response.body.toString());


    try{
      if (response.statusCode == 200) {
        print(data);
        return WeatherHomeModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load album');
      }
    }catch(e){
      print(e);
    }
  }

}