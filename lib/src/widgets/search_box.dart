import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_bloc.dart';
import 'package:weather_forecast_app_zarinpal/src/bloc/city/city_event.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';

class SearchBox extends StatefulWidget {
  const SearchBox(this._searchController, {super.key});
  final TextEditingController _searchController;
  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  CrossFadeState? crossFadeState = CrossFadeState.showFirst;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorPack.lightPurpleGradient,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.search,
              size: 30,
              color: ColorPack.pink,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: "Search your city",
              ),
              maxLines: 1,
              controller: widget._searchController,
              onChanged: (text) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(
                  const Duration(milliseconds: 500),
                  () async {
                    if (RegExp(r"^[a-zA-Z]+(?:[ \t][a-zA-Z]+)*$", caseSensitive: false)
                            .hasMatch(text) &&
                        text.length != 0) {
                      BlocProvider.of<CityBloc>(context).add(
                        FetchMatchedCitiesEvent(widget._searchController.text),
                      );
                    } else if (text.length < 1) {
                      BlocProvider.of<CityBloc>(context).add(ClearCurrentEvent());
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
