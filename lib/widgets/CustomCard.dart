import 'package:base_app/constants/AppSizes.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget widget;
  const CustomCard({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      shadowColor: Colors.tealAccent,
      child: widget,

    );
  }
}
