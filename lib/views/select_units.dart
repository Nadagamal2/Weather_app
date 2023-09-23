import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart%20';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:weather_app/views/search.dart';

import 'dart:math' as math;

import '../layout/cubits/getWeatherHomeCubit/internet_cubit.dart';
import '../utils/Components/MyStar.dart';
import '../utils/Components/The CustomPainter.dart';
import '../utils/Components/evaluated_Buttom.dart';
import '../utils/app_style.dart';
import '../utils/component.dart';

class UnitsScreen extends StatefulWidget {
  @override
  State<UnitsScreen> createState() => _UnitsScreenState();
}

class _UnitsScreenState extends State<UnitsScreen>
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
    // TODO: implement dispose
    super.dispose();
  }

  final units = GetStorage();
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

  var searchController = TextEditingController();

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
                          'Please Select the Unit',
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        FadeInRight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyElevatedButton(
                                width: 150.w,
                                onPressed: () {

                                  navigateTo(context, WeatherSearch());
                                  units.write('unit', 'imperial');
                                  print(units.read('unit'));
                                },
                                borderRadius: BorderRadius.circular(10.r),
                                child: Text('Fahrenheit'),
                              ),
                              MyElevatedButton(
                                width: 150.w,
                                onPressed: () {
                                  navigateTo(context, WeatherSearch());
                                  units.write('unit', 'metric');
                                  print(units.read('unit'));
                                },
                                borderRadius: BorderRadius.circular(10.r),
                                child: Text('Celsius'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
