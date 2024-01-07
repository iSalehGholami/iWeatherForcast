import 'dart:io' show Platform;
import 'package:country_flags/country_flags.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_event.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_event.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/forecast/forecast_state.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/forecast_model.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/extensions/double_extensions.dart';
import 'package:weather_forecast_app_zarinpal/src/utils/extensions/int_extensions.dart';
import 'package:weather_forecast_app_zarinpal/src/widgets/cached_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<ForecastBloc>(context).add(ForecastCheckAllCitiesRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastBloc, ForecastState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(gradient: ColorPack.darkPurpleGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _getBody(context, state),
          ),
        );
      },
    );
  }

  Widget _getBody(BuildContext context, ForecastState state) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<ForecastBloc>(context).add(ForecastCheckAllCitiesRequest());
      },
      backgroundColor: Colors.black,
      color: ColorPack.pink,
      child: CustomScrollView(
        slivers: [
          _getAppBar(context),
          if (state is ForecastLoadingState) ...{
            _getReloadingIndicator(),
          },
          if (state is ForecastLoadedState) ...{
            state.forecastDataList.fold(
              (l) => Text(l),
              (forecastList) {
                return _getForecastsSliverList(forecastList);
              },
            )
          },
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }

  SliverAppBar _getAppBar(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: _getToolBarHeight(),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 2),
        title: Container(
          decoration: BoxDecoration(
            gradient: ColorPack.lightPurpleGradient,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            border: Border.all(
              width: 2,
              color: Colors.black,
            ),
          ),
          child: Column(
            mainAxisAlignment:
                Platform.isIOS ? MainAxisAlignment.center : MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              // Quick fix for new ios devices (14Pro,15,... dynamic island)
              if (Platform.isIOS &&
                  MediaQuery.of(context).orientation != Orientation.landscape) ...{
                const SizedBox(height: 54),
              },
              const Text(
                "iWeatherForecast",
                style: TextStyle(
                  color: ColorPack.pink,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: "roboto",
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "by SGSOFT",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "roboto",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverPadding _getReloadingIndicator() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: SpinKitFadingCircle(
            color: ColorPack.pink,
          ),
        ),
      ),
    );
  }

  SliverList _getForecastsSliverList(List<Forecast> forecastList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildListDismissibleCardItem(
            forecastList,
            index,
            context,
          );
        },
        childCount: forecastList.length,
      ),
    );
  }

  Dismissible _buildListDismissibleCardItem(
    List<Forecast> forecastList,
    int index,
    BuildContext context,
  ) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        BlocProvider.of<CityBloc>(context).add(
          RemoveCityEvent(forecastList[index].city),
        );

        BlocProvider.of<ForecastBloc>(context).add(
          ForecastCheckAllCitiesRequest(),
        );
      },
      confirmDismiss: (direction) async {
        return await _showConfirmationDialog(context, forecastList[index]);
      },
      crossAxisEndOffset: 0,
      movementDuration: const Duration(milliseconds: 500),
      dragStartBehavior: DragStartBehavior.start,
      background: _getBackground(forecastList[index]),
      key: ValueKey<Forecast>(forecastList[index]),
      child: _getCardContainer(context, forecastList, index),
    );
  }

  Container _getCardContainer(BuildContext context, List<Forecast> forecastList, int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        gradient: ColorPack.lightPurpleGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2),
        boxShadow: [
          BoxShadow(
            color: ColorPack.purple1.withOpacity(0.7),
            spreadRadius: 0.3,
            blurRadius: 30,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _getCountryFlag(forecastList[index]),
          ),
          Expanded(
            flex: 4,
            child: _getCityNameAndDateTime(context, forecastList[index]),
          ),
          Expanded(
            flex: 2,
            child: _getHumidityAndTemp(context, forecastList[index]),
          ),
          Expanded(
            flex: 2,
            child: _getWeatherIcon(context, forecastList[index]),
          ),
        ],
      ),
    );
  }

  Widget _getBackground(Forecast forecast) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: Colors.black),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Delete \"${forecast.city.name}\" from the list",
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _getCountryFlag(Forecast forecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CountryFlag.fromCountryCode(
        forecast.city.country,
        width: 40,
        height: 20,
      ),
    );
  }

  Column _getCityNameAndDateTime(BuildContext context, Forecast forecast) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            forecast.city.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              fontFamily: "cm",
            ),
          ),
        ),
        SizedBox(
          child: Text(
            forecast.datetime.getCurrentTime(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.clip,
              fontFamily: "cm",
            ),
          ),
        ),
      ],
    );
  }

  Padding _getHumidityAndTemp(BuildContext context, Forecast forecast) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${forecast.temperature.roundTempString()}°",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: "cm",
            ),
          ),
          Text(
            "${forecast.humidity.toString()}%",
            style: const TextStyle(
              fontSize: 13,
              fontFamily: "cm",
            ),
          ),
        ],
      ),
    );
  }

  Padding _getWeatherIcon(BuildContext context, Forecast forecast) {
    return Padding(
      padding: EdgeInsets.only(
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: CachedIcon(
              iconId: forecast.weatherCondition.iconName,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context, Forecast selectedForecast) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete \"${selectedForecast.city.name}?\""),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              style: TextButton.styleFrom(
                backgroundColor: ColorPack.darkpurple1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(100, 20),
              ),
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              style: TextButton.styleFrom(
                backgroundColor: ColorPack.alizarinRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(100, 20),
              ),
              child: const Text(
                "Delete",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }

  double _getToolBarHeight() {
    final deviceOrientation = MediaQuery.of(context).orientation;
    final deviceScreensize = MediaQuery.of(context).size;
    return deviceOrientation == Orientation.landscape
        ? deviceScreensize.height * 0.2
        : deviceScreensize.height * 0.08;
  }
}
