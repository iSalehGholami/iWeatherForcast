import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size deviceScreenSize = MediaQuery.of(context).size;
    final Orientation deviceOrientation = MediaQuery.of(context).orientation;

    return Container(
      decoration: const BoxDecoration(
        gradient: ColorPack.darkPurpleGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _getScreenBody(deviceOrientation, deviceScreenSize),
      ),
    );
  }

  Widget _getScreenBody(Orientation deviceOrientation, Size deviceScreenSize) {
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        _getSpinner(),
        _getDevInfoBox(deviceOrientation, deviceScreenSize),
      ],
    );
  }

  SizedBox _getSpinner() {
    return const SizedBox(
      child: SpinKitWave(
        color: ColorPack.pink,
        size: 80,
        type: SpinKitWaveType.center,
      ),
    );
  }

  Positioned _getDevInfoBox(Orientation deviceOrientation, Size deviceScreenSize) {
    return Positioned(
      bottom: deviceOrientation == Orientation.landscape
          ? deviceScreenSize.height * 0.1
          : deviceScreenSize.height * 0.05,
      child: Container(
        width: deviceScreenSize.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
          color: ColorPack.purple1,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
        ),
        child: const Center(
          child: Text(
            "Coder: SGSOFT",
            style: TextStyle(fontFamily: 'robotomono', fontSize: 18),
          ),
        ),
      ),
    );
  }
}
