import 'package:equatable/equatable.dart';

import '../../data/model/notifications_model.dart';

enum NotificationStatus {
  initial,
  loading,
  success,
  failure,
  readSuccess,
  readFailure,
}

class NotificationsState extends Equatable {
  final NotificationStatus status;
  final List<NotificationsModel> notifications;
  final String errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.errorMessage = '',
    this.status = NotificationStatus.initial,
  });

  NotificationsState copyWith({
    NotificationStatus? status,
    List<NotificationsModel>? notifications,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [notifications, status, errorMessage];
}
