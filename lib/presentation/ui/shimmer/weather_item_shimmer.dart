import 'package:android_tv_my/utils/shimmer_colors.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherItemShimmer extends StatelessWidget {
  const WeatherItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white),
          color: Colors.white.withValues(alpha: .1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ShimmerColors(child: Text("Monday" ,textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          Divider(height: 4, color: Colors.white),
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ShimmerColors(child: Icon(CupertinoIcons.cloud_sun_fill, size: 40, color: Colors.white)),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ShimmerColors(
                          child: Text(
                            "Today",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ShimmerColors(child: Text("0°C", style: TextStyle(color: Colors.white))),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShimmerColors(child: Icon(IconsaxOutline.wind, color: Colors.white, size: 18)),
                            SizedBox(width: 4),
                            Expanded(
                              child: ShimmerColors(
                                child: Text(
                                  "0 km/h",
                                  style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
