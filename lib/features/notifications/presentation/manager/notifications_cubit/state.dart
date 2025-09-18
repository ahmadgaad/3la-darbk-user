import 'package:equatable/equatable.dart';

import '../../../repositories/model/notifications_model.dart';

class NotificationsState extends Equatable {
  final bool loading;
  final bool success;
  final List<NotificationsModel> notifications;

  const NotificationsState({
    this.notifications = const [],
    this.loading = false,
    this.success = false,
  });

  NotificationsState copyWith({
    List<NotificationsModel>? notifications,
    bool? loading,
    bool? success,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      loading: loading ?? this.loading,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [
        loading,
        notifications,
        success,
      ];
}
