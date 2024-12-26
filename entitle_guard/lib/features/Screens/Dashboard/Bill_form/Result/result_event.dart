part of 'result_bloc.dart';

// Event
abstract class ResultEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event
class ProcessResult extends ResultEvent {
  final File? imageFile;

  ProcessResult(this.imageFile);
}
