import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/views/weather_screen.dart';

import 'layout/cubits/getWeatherHomeCubit/forecast_cubit.dart';
import 'layout/cubits/getWeatherHomeCubit/internet_cubit.dart';
import 'layout/cubits/getWeatherHomeCubit/weather_cubit.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  await GetStorage.init();

  runApp(MyApp(connectivity: Connectivity()));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.connectivity});

  final Connectivity? connectivity;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => WeatherCubit(),
              ),
              BlocProvider(
                create: (context) => InternetCubit(connectivity: connectivity!),
              ),
              BlocProvider(
                create: (context) => ForecastCubit(),
              ),
            ],
            child: MaterialApp(
                title: 'Weather App',
                debugShowCheckedModeBanner: false,
                home: child),
          );
        },
        child: WeatherHome());
  }
}


