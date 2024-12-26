import 'package:entitle_guard/features/Screens/Welcome/Signin/widget/Signin.dart';
import 'package:entitle_guard/features/Screens/Welcome/welcome/bloc/bloc.dart';
import 'package:flutter/material.dart';

class WelcomeContent extends StatefulWidget {
  @override
  _WelcomeContentState createState() => _WelcomeContentState();
}

class _WelcomeContentState extends State<WelcomeContent> {
  int _pageIndex = 0;
  int _clickCounter = 0;

  List<String> _texts = [
    'Discover more, track \n better with habit',
    'Good habit always help \n to meet good peoples',
    'Developing good habit \n stay from bad habit',
  ];

  List<String> _imagePaths = [
    'assets/images/calender.jpg',
    'assets/images/phonebook.jpg',
    'assets/images/list.jpg',
  ];

  late WelcomeBloc _welcomeBloc;

  @override
  void initState() {
    super.initState();
    _welcomeBloc = WelcomeBloc();
  }

  @override
  void dispose() {
    _welcomeBloc.close();
    super.dispose();
  }

  void _nextPage() {
    setState(() {
      _clickCounter++;
      if (_clickCounter == 4) {
        _clickCounter = 0;
        _pageIndex = 0; // Reset to the first page after the third click
      } else if (_clickCounter == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Signin()),
        );
      } else {
        _pageIndex = (_pageIndex + 1) % _texts.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 70,
        ),
        Image.asset(
          _imagePaths[_pageIndex],
          width: 300,
          height: 300,
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          _texts[_pageIndex],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Habit tracking is a way to visualize your \nprogress',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0),
        ),
        SizedBox(
          height: 70,
        ),
        StepIndicator(
          currentIndex: _pageIndex,
          totalSteps: _texts.length,
        ),
        // Flexible(
        //   child:
       ElevatedButton(

            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              //primary:
              //    FitnessAppTheme.nearlyBlue, // Change the button color here
              padding: EdgeInsets.symmetric(
                horizontal: 150,
                vertical: 16,
              ), // Adjust padding to increase size
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        //),
        SizedBox(height: 10.0),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Signin()),
            );
          },
          child: Text(
            'Skip',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalSteps;

  StepIndicator({
    required this.currentIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          margin: EdgeInsets.all(5),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex ? Colors.blue : Colors.grey,
          ),
        );
      }),
    );
  }
}
