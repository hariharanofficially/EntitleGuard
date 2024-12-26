// Define the WelcomeBloc
import 'package:entitle_guard/features/Screens/Welcome/welcome/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Welcome/welcome/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeState.initial);

  Stream<WelcomeState> mapEventToState(WelcomeEvent event) async* {
    if (event == WelcomeEvent.nextPage) {
      yield WelcomeState.navigateToSignIn;
    }
  }
}
