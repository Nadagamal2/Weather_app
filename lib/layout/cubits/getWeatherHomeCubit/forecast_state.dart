part of 'forecast_cubit.dart';

@immutable
abstract class ForecastState {}

class ForecastInitial extends ForecastState {}
class WeatherForecastLoadingState extends ForecastState {
  final WeatherForcastModel weatherForcastModel;

  WeatherForecastLoadingState(this.weatherForcastModel);
}

class WeatherForcastErrorState extends ForecastState {
  final String error;

  WeatherForcastErrorState(this.error);
}