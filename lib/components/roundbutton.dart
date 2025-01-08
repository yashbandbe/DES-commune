import 'package:demoapp/components/colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        color: primarycolor,
        height: 50,
        minWidth: double.infinity,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPress,
      ),
    );
  }
}
