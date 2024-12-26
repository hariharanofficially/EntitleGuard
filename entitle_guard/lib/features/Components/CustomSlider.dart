import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/fitness_app_theme.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double slider = 30;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Expired ",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "( in Month )",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "< 2",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: FitnessAppTheme.lightText),
                  ),
                  Text(
                    "< 5",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: FitnessAppTheme.lightText),
                  ),
                  Text(
                    "All",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: FitnessAppTheme.lightText),
                  ),
                ],
              ),
            ),
            Slider(
                divisions: 2,
                activeColor: FitnessAppTheme.nearlyBlue,
                thumbColor: FitnessAppTheme.nearlyBlue,
                max: 60,
                min: 10,
                value: slider,
                onChanged: (value) {
                  setState(() {
                    slider = value;
                  });
                })
          ],
        )
      ],
    );
  }
}
