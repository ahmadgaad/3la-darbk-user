import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  changeCurrentIndex(int v) async {
    _currentIndex = v;
    emit(ChangeIndex());
  }
}
