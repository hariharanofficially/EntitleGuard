import '../../Utils/colors.dart';
import '../../Utils/fitness_app_theme.dart';
import 'package:flutter/material.dart';

class CustomCategoriesList extends StatefulWidget {
  const CustomCategoriesList({Key? key}) : super(key: key);

  @override
  State<CustomCategoriesList> createState() => _CustomCategoriesListState();
}

class _CustomCategoriesListState extends State<CustomCategoriesList> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Categories",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          children: [
            menuButton(
                onTap: () {
                  setState(() {
                    _index = 0;
                  });
                },
                color: _index == 0 ? FitnessAppTheme.nearlyBlue : form,
                text: "Warrenty",
                textColor: _index == 0 ? Colors.white : SecondaryText,
                width: _index == 0 ? 65 : 85),
            menuButton(
                onTap: () {
                  setState(() {
                    _index = 1;
                  });
                },
                color: _index == 1 ? FitnessAppTheme.nearlyBlue : form,
                text: "Date",
                textColor: _index == 1 ? Colors.white : SecondaryText,
                width: _index == 1 ? 65 : 85),
            menuButton(
                onTap: () {
                  setState(() {
                    _index = 2;
                  });
                },
                color: _index == 2 ? FitnessAppTheme.nearlyBlue : form,
                text: "Type",
                textColor: _index == 2 ? Colors.white : SecondaryText,
                width: _index == 2 ? 65 : 85),
          ],
        ),
      ],
    );
  }

  menuButton(
      {required String text,
      required Color color,
      required Color textColor,
      required double width,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: width,
          height: 45,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
