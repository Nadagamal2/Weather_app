part of 'weather_cubit.dart';

@immutable
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoadingState extends WeatherState {
  final WeatherHomeModel weatherHomeModel;

  WeatherLoadingState(this.weatherHomeModel);
}

class WeatherErrorState extends WeatherState {
  final String error;

  WeatherErrorState(this.error);
}


