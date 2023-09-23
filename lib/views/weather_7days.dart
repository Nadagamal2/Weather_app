import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart%20';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/layout/cubits/getWeatherHomeCubit/forecast_cubit.dart';
import 'package:weather_app/views/search.dart';

import 'package:weather_app/views/weather_screen.dart';

import '../layout/cubits/getWeatherHomeCubit/internet_cubit.dart';
import '../utils/Components/evaluated_Buttom.dart';
import '../utils/app_style.dart';
import '../utils/component.dart';

class WeatherDayes extends StatelessWidget {
  WeatherDayes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.Scaffold,
      appBar: AppBar(
        toolbarHeight: 65.h,
        elevation: 0,
        backgroundColor: Styles.Scaffold,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => WeatherHome()),
                (Route<dynamic> route) => false);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Styles.colorWhite,
            size: 14.sp,
          ),
        ),
        centerTitle: true,
        title: Row(
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: Styles.colorWhite,
              size: 20.sp,
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              '5 days forecast',
              style: TextStyle(
                color: Styles.colorWhite,
                fontSize: 28.sp,
                fontFamily: 'hubbal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if (state is InternetConnected &&
                  state.connectionType == ConnectionType.wifi ||
              state is InternetConnected &&
                  state.connectionType == ConnectionType.mobile) {
            return BlocBuilder<ForecastCubit, ForecastState>(
              builder: (context, state) {
                if (state is WeatherForecastLoadingState) {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Column(
                          children: BlocProvider.of<ForecastCubit>(context)
                              .weatherForcastModel
                              .list
                              .map(
                                (e) => FadeInRight(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        right: 12.w,
                                        left: 12.w,
                                        bottom: 10.h,
                                        top: 15.h),
                                    decoration: BoxDecoration(
                                      color: Styles.color5,
                                      borderRadius: BorderRadius.circular(75.r),
                                      gradient: LinearGradient(
                                        colors: [
                                          Styles.Color1,
                                          Styles.Color2,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        stops: [.2, .9],
                                      ),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                          right: 1.w,
                                          left: 1.w,
                                          bottom: 10.h,
                                          top: 1.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(65.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Styles.boxShadow,
                                            spreadRadius: 0,
                                            blurRadius: 5,
                                            offset: Offset(-1,
                                                0), // changes position of shadow
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          colors: [
                                            Styles.color3,
                                            Styles.color4,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          stops: [.1, .85],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(10.h),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10.h),
                                            myDivider(),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 130.h,
                                                  width: 130.h,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            'http://openweathermap.org/img/wn/${e.weather[0].icon}@4x.png'),
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 140.w,
                                                      child: Text(
                                                        '${DateFormat('dd-MMM-yyyy / h:mm a').format(e.dtTxt)}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Styles
                                                              .colorWhite2,
                                                          fontSize: 11,
                                                          fontFamily: 'hubbal',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${e.main.temp.toInt()}',
                                                          style: TextStyle(
                                                            fontSize: 50.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Styles
                                                                .colorWhite,
                                                            fontFamily:
                                                                'hubbal',
                                                          ),
                                                        ),
                                                        Text(
                                                          '°',
                                                          style: TextStyle(
                                                            fontSize: 49.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Styles
                                                                .colorWhite,
                                                            fontFamily:
                                                                'hubbal',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      '${e.weather[0].description}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Styles.colorWhite3,
                                                        fontSize: 18.sp,
                                                        fontFamily: 'hubbal',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            myDivider(),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Something Went Wrong!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.sp,
                          color: Styles.colorWhite,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      MyElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WeatherSearch()),
                              (route) => false);
                        },
                        child: Text('Go to Search page!'),
                        borderRadius: BorderRadius.circular(10.r),
                      )
                    ],
                  ));
                }
              },
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
                      style:
                          TextStyle(color: Styles.colorWhite, fontSize: 22.sp),
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
      ),
    );
  }
}
