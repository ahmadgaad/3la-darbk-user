import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/notification_repository.dart';
import 'notification_states.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _notificationsRepo;
  NotificationsCubit(this._notificationsRepo)
    : super(const NotificationsState(status: NotificationStatus.initial));

  Future<void> getNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading, notifications: []));
    final result = await _notificationsRepo.getNotifications();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.failure,
            errorMessage: failure.message,
            notifications: [],
          ),
        );
      },
      (notification) {
        emit(
          state.copyWith(
            status: NotificationStatus.success,
            notifications: notification,
          ),
        );
      },
    );
  }

  Future<void> readNotifications() async {
    final result = await _notificationsRepo.readNotifications();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: NotificationStatus.readFailure,
            errorMessage: failure.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            status: NotificationStatus.readSuccess,
            notifications:
                state.notifications.map((e) => e.copyWith(isRead: 1)).toList(),
          ),
        );
      },
    );
  }
}
