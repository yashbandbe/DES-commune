import 'package:demoapp/onboarding_screen/dummy_data.dart';
import 'package:demoapp/onboarding_screen/onboarding_item.dart';
import 'package:demoapp/screens/home_screen.dart';
import 'package:demoapp/screens/homescreen.dart';
import 'package:demoapp/screens/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectIndex = 0;
  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                "SKIP",
                style: Theme.of(context).textTheme.labelLarge,
              )),
          SizedBox()
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                  controller: controller,
                  onPageChanged: (i) {
                    setState(() {
                      selectIndex = i;
                    });
                  },
                  itemCount: KDummyData.onboardingItemList.length,
                  itemBuilder: (context, index) {
                    return ContentTemplate(
                      item: KDummyData.onboardingItemList[index],
                    );
                  }),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ...List.generate(
                      KDummyData.onboardingItemList.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                        height: 8,
                        width: selectIndex == index ? 24 : 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: selectIndex == index
                              ? Color.fromARGB(255, 1, 27, 69)
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    controller.animateToPage(selectIndex + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  onDoubleTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Color.fromARGB(255, 1, 27, 69),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}

class ContentTemplate extends StatelessWidget {
  const ContentTemplate({
    super.key,
    required this.item,
  });

  final OnboardingItemModel item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Image.asset(item.image),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          item.title,
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(
          height: size.height * 0.05,
        ),
        Text(
          item.subtitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(),
        ),
      ],
    );
  }
}
