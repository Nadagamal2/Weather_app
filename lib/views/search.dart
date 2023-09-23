import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart%20';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/layout/cubits/getWeatherHomeCubit/weather_cubit.dart';
import 'package:weather_app/views/select_units.dart';
import 'package:weather_app/views/weather_screen.dart';

import '../layout/cubits/getWeatherHomeCubit/forecast_cubit.dart';
import '../layout/cubits/getWeatherHomeCubit/internet_cubit.dart';

import '../utils/app_style.dart';
import '../utils/component.dart';

// ignore: must_be_immutable
class WeatherSearch extends StatelessWidget {
  final units = GetStorage();

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.Scaffold,
        body: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetConnected &&
                    state.connectionType == ConnectionType.wifi ||
                state is InternetConnected &&
                    state.connectionType == ConnectionType.mobile) {
              return Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => UnitsScreen()),
                                  (Route<dynamic> route) => false);
                              // Navigator.pop(context);
                            },
                            icon: Center(
                                child: Icon(
                              Icons.arrow_back_ios,
                              color: Styles.colorWhite,
                            )))
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    defaultFormField(
                      controller: searchController,
                      Type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'enter text to search';
                        }
                        return null;
                      },
                      lable: 'Search',
                      onSubmit: (String text) {
                        var getWeatherCubit =
                            BlocProvider.of<WeatherCubit>(context);
                        getWeatherCubit.getWeather(
                            cityName: text, units: '${units.read('unit')}');
                        var getWeatherForecastCubit =
                            BlocProvider.of<ForecastCubit>(context);
                        getWeatherForecastCubit.getWeatherForecast(
                            cityName: text, units: '${units.read('unit')}');
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => WeatherHome()),
                            (Route<dynamic> route) => false);
                        //   navigateTo(context, WeatherHome());
                        log(text);
                      },
                      prefix: Icons.search,
                    ),
                  ],
                ),
              );
            } else if (state is InternetDisconnected) {
              return Scaffold(
                backgroundColor: Styles.Scaffold,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/wifi.png'),
                        color: Styles.colorWhite,
                        height: 90.h,
                      ),
                      Text(
                        'No Internet Connection !',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Styles.colorWhite, fontSize: 22.sp),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Styles.color3),
              ),
            );
          },
        ));
  }
}
