import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/repositories.dart';
import 'state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _notificationsRepo;
  NotificationsCubit(this._notificationsRepo)
      : super(const NotificationsState()){
        getNotifications();
      }

  getNotifications() async {
    final result = await _notificationsRepo.getNotifications();
    result.fold((notification) => emit(state.copyWith(loading: false, success: true, notifications: notification)),
        (error) => emit(state.copyWith(loading: false, success: false)));
  }
    readNotifications() async {
    await _notificationsRepo.readNotifications();
    emit(
      state.copyWith(
        loading: false,
        success: true,
        notifications:
            state.notifications.map((e) => e.copyWith(isRead: 1)).toList(),
      ),
    );
  }
}
