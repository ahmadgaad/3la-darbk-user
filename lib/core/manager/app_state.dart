part of 'app_cubit.dart';

@immutable
sealed class AppState extends Equatable {}

final class AppInitial extends AppState {
  @override
  List<Object?> get props => [];
}

final class ChangeIndex extends AppState {
  @override
  List<Object?> get props => [];
}
