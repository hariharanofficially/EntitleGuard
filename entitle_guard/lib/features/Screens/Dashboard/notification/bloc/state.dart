// Define states for the notification screen BLoC
class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<String> notifications;

  NotificationLoaded(this.notifications);
}
