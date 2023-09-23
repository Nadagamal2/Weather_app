import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart%20';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/layout/cubits/getWeatherHomeCubit/weather_cubit.dart';
import 'package:weather_app/views/select_units.dart';
import 'dart:math' as math;

import '../layout/cubits/getWeatherHomeCubit/internet_cubit.dart';
import '../utils/Components/MyStar.dart';
import '../utils/Components/The CustomPainter.dart';
import '../utils/Components/evaluated_Buttom.dart';
import '../utils/app_style.dart';
import '../utils/component.dart';
import 'search.dart';
import 'weather_7days.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({Key? key}) : super(key: key);

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late List<MyStar> myStars;

  @override
  void initState() {
    super.initState();

    myStars = <MyStar>[];
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        for (final star in myStars) {
          star.isEnable = math.Random().nextBool();
        }

        animationController.forward();
      }
    });
    animation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine));
    animation.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  void postFrameCallback(_) {
    if (!mounted) {
      return;
    }

    final size = MediaQuery.of(context).size;
    if (myStars.isEmpty) {
      myStars = List.generate(60, (index) {
        double velocityX = 2 * (math.Random().nextDouble()); //max velocity 2
        double velocityY = 2 * (math.Random().nextDouble());

        velocityX = math.Random().nextBool() ? velocityX : -velocityX;
        velocityY = math.Random().nextBool() ? velocityY : -velocityY;

        return MyStar(
            isEnable: math.Random().nextBool(),
            innerCirclePoints: 4,
            beamLength: math.Random().nextDouble() * (8 - 2) + 2,
            innerOuterRadiusRatio: 0.0,
            angleOffsetToCenterStar: 0,
            center: Offset(size.width * (math.Random().nextDouble()),
                size.height * (math.Random().nextDouble())),
            velocity: Offset(velocityX, velocityY),
            color: Colors.white);
      });
    } else {
      for (final star in myStars) {
        star.center = star.center + star.velocity;
        if (star.isEnable) {
          star.innerOuterRadiusRatio = animation.value;

          if (star.center.dx >= size.width) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(-1, 1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(size.width, star.center.dy);
          } else if (star.center.dx <= 0) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(1, -1);
            }

            star.center = Offset(0, star.center.dy);
          } else if (star.center.dy >= size.height) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, -1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(star.center.dx, size.height);
          } else if (star.center.dy <= 0) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(-1, 1);
            }

            star.center = Offset(star.center.dx, 0);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);

    return Scaffold(
      backgroundColor: Styles.Scaffold,
      body: BlocBuilder<InternetCubit, InternetState>(
        builder: (context, state) {
          if (state is InternetConnected &&
                  state.connectionType == ConnectionType.wifi ||
              state is InternetConnected &&
                  state.connectionType == ConnectionType.mobile) {
            return BlocBuilder<WeatherCubit, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return Stack(
                    children: [
                      CustomPaint(
                          size: MediaQuery.of(context).size,
                          painter: StarPainter(
                            myStars: myStars,
                          )),
                      Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 70.h,
                            ),
                            Text(
                              'Welcome !',
                              style: TextStyle(
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'Search for the city to get the weather !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            MyElevatedButton(
                              width: 150.w,
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => UnitsScreen()),
                                    (Route<dynamic> route) => false);
                                // navigateTo(context, UnitsScreen());
                              },
                              borderRadius: BorderRadius.circular(10.r),
                              child: Text('Get Started'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (state is WeatherLoadingState) {
                  return Container(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
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
                                borderRadius: BorderRadius.circular(65.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Styles.boxShadow,
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: Offset(
                                        -1, 0), // changes position of shadow
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20.h),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WeatherSearch()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          icon: Icon(
                                            Icons.search,
                                            color: Colors.white.withOpacity(.8),
                                            size: 25.sp,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: Styles.colorWhite,
                                                )),
                                            SizedBox(width: 5.w),
                                            Text(
                                              BlocProvider.of<WeatherCubit>(
                                                      context)
                                                  .weatherHomeModel
                                                  .name!,
                                              style: TextStyle(
                                                color: Styles.colorWhite,
                                                fontSize: 22.sp,
                                                fontFamily: 'hubbal',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.transparent,
                                            size: 25.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 180.h,
                                    width: 180.h,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              'http://openweathermap.org/img/wn/${BlocProvider.of<WeatherCubit>(context).weatherHomeModel.weather![0].icon}@4x.png'),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${BlocProvider.of<WeatherCubit>(context).weatherHomeModel.main!.temp!.toInt()}',
                                        style: TextStyle(
                                          fontSize: 90.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Styles.colorWhite,
                                          fontFamily: 'hubbal',
                                        ),
                                      ),
                                      Text(
                                        '°c',
                                        style: TextStyle(
                                          fontSize: 80.sp,
                                          color: Styles.colorWhite,
                                          fontFamily: 'hubbal',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    BlocProvider.of<WeatherCubit>(context)
                                        .weatherHomeModel
                                        .weather![0]
                                        .main!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Styles.colorWhite2,
                                      fontSize: 40.sp,
                                      fontFamily: 'hubbal',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd-MMM-yyyy')
                                        .format(DateTime.now()),
                                    style: TextStyle(
                                      color: Styles.colorWhite3,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'hubbal',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 17.h,
                                  ),
                                  myDivider(),
                                  SizedBox(
                                    height: 17.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.wind_power,
                                              color: Styles.colorWhite4,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Text(
                                              '${BlocProvider.of<WeatherCubit>(context).weatherHomeModel.wind!.speed!.toInt()} km/h',
                                              style: TextStyle(
                                                color: Styles.colorWhite,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                            Text(
                                              'Wind',
                                              style: TextStyle(
                                                color: Styles.colorWhite3,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.water_drop_rounded,
                                              color: Styles.colorWhite4,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Text(
                                              '${BlocProvider.of<WeatherCubit>(context).weatherHomeModel.main!.humidity}%',
                                              style: TextStyle(
                                                color: Styles.colorWhite,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                            Text(
                                              'Humidity',
                                              style: TextStyle(
                                                color: Styles.colorWhite3,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.sunny_snowing,
                                              color: Styles.colorWhite4,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Text(
                                              '${BlocProvider.of<WeatherCubit>(context).weatherHomeModel.clouds!.all}%',
                                              style: TextStyle(
                                                color: Styles.colorWhite,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                            Text(
                                              'Chance of rain',
                                              style: TextStyle(
                                                color: Styles.colorWhite3,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.sp,
                                                fontFamily: 'hubbal',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 45.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      '5 days',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.sp,
                                        color: Styles.colorWhite,
                                        fontFamily: 'hubbal',
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigateTo(context, WeatherDayes());
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Styles.colorWhite,
                                            width: .4.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Styles.colorWhite,
                                          size: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
