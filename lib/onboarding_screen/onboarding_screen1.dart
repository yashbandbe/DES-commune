import 'package:demoapp/components/colors.dart';
import 'package:demoapp/components/text_String.dart';
import 'package:demoapp/onboarding_screen/model_on_boarding.dart';
import 'package:demoapp/onboarding_screen/on_boarding_page_widget.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:demoapp/screens/selectuser.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen1 extends StatefulWidget {
  OnBoardingScreen1({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  final controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pages = [
      OnBoardingPageWidget(
          model: OnBoardingModel(
        image: 'assets/pngegg.png',
        title: tOnBoardingTitle1,
        subTitle: tOnBoardingSubTitle1,
        counterText: tOnBoardingCounter1,
        height: size.height,
        bgColor: tOnBoardingPage1Colors,
      )),
      OnBoardingPageWidget(
          model: OnBoardingModel(
        image: 'assets/ob1.png',
        title: tOnBoardingTitle2,
        subTitle: tOnBoardingSubTitle2,
        counterText: tOnBoardingCounter2,
        height: size.height,
        bgColor: tOnBoardingPage2Colors,
      )),
      OnBoardingPageWidget(
          model: OnBoardingModel(
        image: 'assets/obs5.png',
        title: tOnBoardingTitle3,
        subTitle: tOnBoardingSubTitle3,
        counterText: tOnBoardingCounter3,
        height: size.height,
        bgColor: tOnBoardingPage3Colors,
      ))
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          LiquidSwipe(
            pages: pages,
            liquidController: controller,
            onPageChangeCallback: onPageChangedCallback,
            slideIconWidget: const Icon(Icons.arrow_back_ios),
            enableSideReveal: true,
          ),
          Positioned(
              bottom: 60.0,
              child: OutlinedButton(
                onPressed: () {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                      color: Colors.black87, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              )),
          Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelectionScreen()));
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey),
                  ))),
          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              activeIndex: controller.currentPage,
              count: 3,
              effect: const WormEffect(
                  activeDotColor: Color(0xff272727), dotHeight: 5.0),
            ),
          ),
        ],
      ),
    );
  }

  void onPageChangedCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}
