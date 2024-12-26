// BLoC
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../../../../data/Models/apimodels.dart';
import '../../../../../data/Services/api.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  ResultBloc() : super(ResultInitial()) {
    on<ProcessResult>(_onProcessResult);
  }

  Future<void> _onProcessResult(
    ProcessResult event,
    Emitter<ResultState> emit,
  ) async {
    emit(ResultLoading());
    try {
      // Call the API and pass the image file
      final result = await uploadFile(event.imageFile!);

      // Check if the API returned success
      if (result['success']) {
        var data = result['data'];
        Bill bill = Bill.fromJson(data);
        emit(ResultSuccess(bill));
      } else {
        emit(ResultFailure(result['message'] ?? 'Unknown error occurred'));
      }
    } catch (e) {
      // Catch any unexpected errors
      emit(ResultFailure('An error occurred during result processing: $e'));
    }
  }
}
