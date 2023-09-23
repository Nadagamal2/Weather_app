import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/Weather_forcast.dart';
import '../../../services/forcast_weather.dart';

part 'forecast_state.dart';

class ForecastCubit extends Cubit<ForecastState> {
  ForecastCubit() : super(ForecastInitial());
   late WeatherForcastModel weatherForcastModel;
  getWeatherForecast({required String cityName,required String units}) async {
    try {
      weatherForcastModel =
      (await WeatherForecastSevices().getWeatherForecastData(cityName,units))!;
      emit(WeatherForecastLoadingState(weatherForcastModel));
    } catch (e) {
      emit(WeatherForcastErrorState(e.toString()));
    }
  }
}
