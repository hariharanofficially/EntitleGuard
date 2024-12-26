import 'package:entitle_guard/features/Screens/Dashboard/notification/bloc/event.dart';
import 'package:entitle_guard/features/Screens/Dashboard/notification/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleSignInAccount; // Add this property
  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {
      await loginUser(emit, event);
    });
  }

  Future<void> loginUser(
      Emitter<NotificationState> emit, NotificationEvent event) async {
    // Generate a list of notifications
    final notifications =
        List.generate(10, (index) => 'Notification ${index + 1}');
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    // Set the GoogleSignInAccount property
    _googleSignInAccount = googleSignInAccount;
    // Emit the NotificationLoaded state with the list of notifications
    emit(NotificationLoaded(notifications));
  }

  // Getter to access the GoogleSignInAccount instance
  GoogleSignInAccount? get googleSignInAccount => _googleSignInAccount;
}
