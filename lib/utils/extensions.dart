import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

extension BuildContextExtensions on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get getScreenHeight => _size.height;

  double get getScreenWidth => _size.width;
}

extension CustomImage on String {
  Image image({double? width, double? height, BoxFit? fit, Color? color}) {
    return Image.asset(this, fit: fit, color: color, height: height, width: width);
  }

  SvgPicture svg({double? width, double? height, BoxFit fit = BoxFit.contain, Color? color}) {
    return SvgPicture.asset(
      this,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

extension FormattedDateTimeString on String {
  DateTime? get stringToDateTime {
    return DateTime.tryParse(this);
  }

  String get formattedDate {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('dd MMM').format(date) : this;
  }

  String get formattedWeekDay {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('EEEE').format(date) : this;
  }

  String get formattedDateTime {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('dd.MM.yyyy HH:mm').format(date) : this;
  }

  String get formattedTime {
    var date = DateTime.tryParse(this);
    return date != null ? DateFormat('HH:mm').format(date) : this;
  }
}