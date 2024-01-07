import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast_app_zarinpal/src/constants/const.dart';

class CachedIcon extends StatelessWidget {
  final String? iconId;
  final double radius;
  const CachedIcon({super.key, this.iconId, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: "${APIConfig.IconUrlPrefix}${iconId ?? '01d'}${APIConfig.IconUrlSuffix}",
        placeholder: (context, url) {
          return Container(
            decoration: const BoxDecoration(
              gradient: ColorPack.darkPurpleGradient,
            ),
          );
        },
        errorWidget: (context, url, error) => Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            gradient: ColorPack.darkPurpleGradient,
          ),
          child: const Center(
            child: Text("❌"),
          ),
        ),
      ),
    );
  }
}
