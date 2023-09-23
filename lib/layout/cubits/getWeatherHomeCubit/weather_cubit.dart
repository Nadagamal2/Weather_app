import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/model/weather_home_model.dart';
import 'package:weather_app/services/weatherServices.dart';

import '../../../model/Weather_forcast.dart';
import '../../../services/forcast_weather.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());
  late WeatherHomeModel weatherHomeModel;

  getWeather({required String cityName,required String units}) async {
    try {
        weatherHomeModel =
          (await WeatherSevices().getWeatherData(cityName,units))!;
      emit(WeatherLoadingState(weatherHomeModel!));
    } catch (e) {
      emit(WeatherErrorState(e.toString()));
    }
  }

}
