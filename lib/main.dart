import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/screens/home_screen.dart';
import 'package:weather_forecast_app_zarinpal/src/screens/search_screen.dart';
import 'package:weather_forecast_app_zarinpal/src/screens/splash_screen.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getItInit();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: CityBloc(),
        ),
        BlocProvider.value(
          value: ForecastBloc(),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int index = 0;
  bool isLoading = true;

  @override
  void initState() {
    _startLoadingTimer();
    super.initState();
  }

  void _startLoadingTimer() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: isLoading ? SplashScreen() : _homeBuilder(),
    );
  }

  Scaffold _homeBuilder() {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: IndexedStack(
                  index: index,
                  children: [
                    HomeScreen(),
                    SearchScreen(),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _getBottomNavbar(),
          ),
        ],
      ),
    );
  }

  Widget _getBottomNavbar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 50,
      margin: EdgeInsets.symmetric(
        vertical: 30,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        gradient: ColorPack.lightPurpleGradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _generateNavButton(Icons.home_outlined, 0),
          _generateNavButton(Icons.search_outlined, 1),
        ],
      ),
    );
  }

  Widget _generateNavButton(IconData icon, _index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: ColorPack.bravoBlue,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: CircleBorder(),
      ),
      onPressed: () {
        setState(() {
          index = _index;
        });
      },
      child: Icon(
        icon,
        color: index == _index
            ? ColorPack.pink
            : MediaQuery.of(context).platformBrightness == Brightness.dark
                ? ColorPack.bravoBlue
                : Colors.black,
        size: 30,
      ),
    );
  }
}
