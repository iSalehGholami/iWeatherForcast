import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_event.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_state.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';
import 'package:weather_forecast_app_zarinpal/src/data/models/city_model.dart';
import 'package:weather_forecast_app_zarinpal/src/widgets/search_box.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        if (state is CityClearSearchState) {
          searchController.clear();
        }
        return Container(
          decoration: BoxDecoration(
            gradient: ColorPack.darkPurpleGradient,
          ),
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: _getBodyScrollView(state),
            ),
          ),
        );
      },
    );
  }

  CustomScrollView _getBodyScrollView(CityState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          sliver: SliverToBoxAdapter(
            child: SearchBox(searchController),
          ),
        ),
        if (state is CityLoadingState) ...{
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: SpinKitFadingCircle(
                  color: ColorPack.pink,
                ),
              ),
            ),
          ),
        },
        if (state is CityLoadedState) ...{
          state.cities.fold((error) => Text(error), (matchedCities) {
            return _buildMatchedCitiesList(matchedCities);
          })
        },
        if (state is CityDoneState) ...{
          _addedPopupDialog(state),
        }
      ],
    );
  }

  SliverPadding _addedPopupDialog(CityDoneState state) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            gradient: ColorPack.lightPurpleGradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.black),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
              Positioned(
                bottom: 10,
                right: 15,
                child: ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CityBloc>(context).add(ClearCurrentEvent());
                  },
                  child: Text("OK"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: ColorPack.purple1,
                    textStyle: TextStyle(
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontSize: 20,
                    ),
                    fixedSize: Size(120, 60),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchedCitiesList(List<City> matchedCities) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _generateCountryCard(context, matchedCities, index);
        },
        childCount: matchedCities.length,
      ),
    );
  }

  InkWell _generateCountryCard(BuildContext context, List<City> matchedCities, int index) {
    return InkWell(
      onTap: () async {
        BlocProvider.of<CityBloc>(context).add(
          AddCityEvent(
            matchedCities[index],
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          gradient: ColorPack.lightPurpleGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _getCountryFlag(matchedCities, index),
            _getCityInfo(matchedCities, index, context),
          ],
        ),
      ),
    );
  }

  Padding _getCountryFlag(List<City> matchedCities, int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: CountryFlag.fromCountryCode(
        matchedCities[index].country,
        height: 50,
        width: 50,
      ),
    );
  }

  Padding _getCityInfo(List<City> matchedCities, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: matchedCities[index].state != ""
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    matchedCities[index].name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    matchedCities[index].state,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : Text(
              matchedCities[index].name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
