import 'package:android_tv_my/data/model/weather_model.dart';
import 'package:android_tv_my/utils/extensions.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeatherItemView extends StatefulWidget {
  final WeatherModel item;
  final int index;

  const WeatherItemView({super.key, required this.item, required this.index});

  @override
  State<WeatherItemView> createState() => _WeatherItemViewState();
}

class _WeatherItemViewState extends State<WeatherItemView> {

  bool isFocused = false;
  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.home)) {
          // widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.all(isFocused?0:6),
        decoration: BoxDecoration(
          color: isFocused ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused ? Colors.blue : Colors.transparent,
            width: 3,
          ),
        ),
        child: Container(
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
                child: Text(widget.item.date.formattedWeekDay,
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Divider(height: 4, color: Colors.white),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(_getIcon(widget.item.weatherCode), size: 40, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.index == 0 ? "Today" : widget.item.date.formattedDate,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text("${widget.item.temperature}°C", style: TextStyle(color: Colors.white)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(IconsaxOutline.wind, color: Colors.white, size: 18),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    "${widget.item.windMax} km/h",
                                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
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
        ),
      ),
    );
  }
}

IconData _getIcon(int code) {
  return switch (code) {
  // 0 – Clear sky
    0 => CupertinoIcons.sun_max_fill,

  // 1, 2, 3 – Mainly clear, partly cloudy, overcast
    1 || 2 || 3 => CupertinoIcons.cloud_sun_fill,

  // 45, 48 – Fog
    45 || 48 => CupertinoIcons.cloud_fog_fill,

  // 51, 53, 55 – Drizzle
    51 || 53 || 55 => CupertinoIcons.cloud_drizzle_fill,

  // 56, 57 – Freezing drizzle
    56 || 57 => CupertinoIcons.cloud_snow,

  // 61, 63, 65 – Rain
    61 || 63 || 65 => CupertinoIcons.cloud_rain_fill,

  // 66, 67 – Freezing rain
    66 || 67 => CupertinoIcons.cloud_hail_fill,

  // 71, 73, 75 – Snow fall
    71 || 73 || 75 => CupertinoIcons.cloud_snow_fill,

  // 77 – Snow grains
    77 => CupertinoIcons.snow,

  // 80, 81, 82 – Rain showers
    80 || 81 || 82 => CupertinoIcons.cloud_heavyrain_fill,

  // 85, 86 – Snow showers
    85 || 86 => CupertinoIcons.cloud_snow_fill,

  // 95 – Thunderstorm
    95 => CupertinoIcons.cloud_bolt_fill,

  // 96, 99 – Thunderstorm with hail
    96 || 99 => CupertinoIcons.cloud_hail_fill,

  // Default
    _ => CupertinoIcons.cloud_fill,
  };
}