import 'package:country_flags/country_flags.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
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
          decoration: BoxDecoration(gradient: ColorPack.darkPurpleGradient),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _getBody(context, state),
          ),
        );
      },
    );
  }

  RefreshIndicator _getBody(BuildContext context, ForecastState state) {
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
          SliverPadding(
            padding: EdgeInsets.only(bottom: 100),
          ),
        ],
      ),
    );
  }

  SliverAppBar _getAppBar(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: MediaQuery.of(context).orientation == Orientation.landscape ? 120 : 70,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
            decoration: BoxDecoration(
              gradient: ColorPack.lightPurpleGradient,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              border: Border.all(
                width: 2,
                color: Colors.black,
              ),
            ),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Positioned(
                  top: 55,
                  child: Text(
                    "iWeatherForecast",
                    style: TextStyle(
                      color: ColorPack.pink,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.theGirlNextDoor().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                  bottom: 15,
                  child: Text(
                    "by SGSOFT",
                    style: TextStyle(),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  SliverPadding _getReloadingIndicator() {
    return SliverPadding(
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
      movementDuration: Duration(milliseconds: 500),
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
            color: ColorPack.purple1,
            spreadRadius: 0.3,
            blurRadius: 30,
            blurStyle: BlurStyle.outer,
            offset: Offset(0, 9),
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
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
                  style: TextStyle(
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
              fontFamily: GoogleFonts.chelseaMarket().fontFamily,
            ),
          ),
        ),
        SizedBox(
          child: Text(
            forecast.datetime.getCurrentTime(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.clip,
              fontFamily: GoogleFonts.chelseaMarket().fontFamily,
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.chelseaMarket().fontFamily,
            ),
          ),
          Text(
            "${forecast.humidity.toString()}%",
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.chelseaMarket().fontFamily,
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
          title: Text("Delete Confirmation"),
          content: Text("Are you sure you want to delete \"${selectedForecast.city.name}?\""),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: Text("Cancel"),
              style: TextButton.styleFrom(
                backgroundColor: ColorPack.darkpurple1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: Size(100, 20),
              ),
            ),
            SizedBox(width: 10),
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
                fixedSize: Size(100, 20),
              ),
              child: Text(
                "Delete",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
