import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'state.dart';

class SettingsInfoCubit extends Cubit<SettingsInfoState> {
  final SettingsInfoRepository _settingsInfoRepository;
  SettingsInfoCubit(this._settingsInfoRepository)
      : super(const SettingsInfoState());

  getSettingInfo() async {
    final result = await _settingsInfoRepository.getSettingsInfo();
    result.fold(
      (settingsInfo) => emit(state.copyWith(settingsInfo: settingsInfo)),
      (exception) => emit(state.copyWith()),
    );
  }
}
