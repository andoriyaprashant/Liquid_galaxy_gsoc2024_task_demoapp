import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_galaxy_demo_app/views/orbit_entity.dart';
import '../views/images.dart';

extension SizedBoxPadding on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}

extension ZoomLG on num {
  double get zoomLG =>
      Const.lgZoomScale / pow(2, this); // Formula to match zoom of GMap with LG
}

extension SetPercentage on num {
  double get setTemperaturePercentage => min(max((this + 30) / 85, 0),
      1); // Lowest temp = -30, highest +55, total variation = 85
  double get setPressurePercentage => min(max((this - 800) / 500, 0),
      1); // Lowest pressure +800, highest +1300, total variation = 500
  double get setUVPercentage => this / 15; // Max uv = 15
  double get setPercentage => this / 100; // Max 100
  double get setPercentageAbout => this / 10000; // Max point = 10000
  double get setTreePercentage => this / 300000000000; // Max point = 10000
}

extension Parser on String {
  String get parseIcon =>
      '${ImageConst.allWeather}${split('/').reversed.elementAt(1)}/${split('/').last}'; // Retu
  String get parseIconOnline =>
      '${ImageConst.allWeatherOnline}${split('/').reversed.elementAt(1)}/${split('/').last}'; // // rn a string like this "assets/logos/weather/day/mist.png"
  String get parseTime =>
      split(' ').last; // Parse time from "MM-DD-YYYY TT:TT" format
  String get parseDay =>
      split(' ')[0].split('-')[2]; // Parse day from "MM-DD-YYYY TT:TT" format
}
