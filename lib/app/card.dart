import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({
    required this.colour, 
    this.cardChild, 
    required this.onPress,
  });
  
  final Color colour; // Change MaterialColor to Color
  final Widget? cardChild;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: colour, // Use the provided colour here
          borderRadius: BorderRadius.circular(20),
        ),
        child: cardChild,
      ),
    );
  }
}
