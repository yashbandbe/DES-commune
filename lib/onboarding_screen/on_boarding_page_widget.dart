import 'package:demoapp/onboarding_screen/model_on_boarding.dart';
import 'package:flutter/material.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      color: model.bgColor,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image(
          image: AssetImage(model.image),
          height: model.height * 0.5,
        ),
        Column(
          children: [
            Text(
              model.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              model.subTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          model.counterText,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(
          height: 80.0,
        )
      ]),
    );
  }
}
