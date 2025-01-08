// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';

class OnBoardingModel {
  final String image;
  final String title;
  final String subTitle;
  final String counterText;
  final Color bgColor;
  final double height;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.counterText,
    required this.bgColor,
    required this.height,
  });
}
