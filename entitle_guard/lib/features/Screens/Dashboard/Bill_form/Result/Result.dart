// UI (View)
import 'dart:io';
import 'package:entitle_guard/features/Screens/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/Models/apimodels.dart';
import '../scanning/verify/Verifyitems.dart';
import 'result_bloc.dart';

class Result extends StatelessWidget {
  final String imagePath;
  Bill bill;

  Result({Key? key, required this.imagePath, required this.bill})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResultBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Result',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: 'Nexa Bold',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ),
        body: BlocConsumer<ResultBloc, ResultState>(
          listener: (context, state) {
            if (state is ResultSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Result Processed Successfully')),
              );
              bill = state.bill;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Verifyitems(
                    bill: bill,
                  ),
                ),
              );
            } else if (state is ResultFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            if (state is ResultLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.file(File(imagePath)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<ResultBloc>()
                          .add(ProcessResult(File(imagePath)));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Process Image',
                      style: TextStyle(
                        color: Colors.black, // FitnessAppTheme.darkText,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
