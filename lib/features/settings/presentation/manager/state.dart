import 'package:equatable/equatable.dart';

import '../../repositories/models/settings_info_model.dart';

class SettingsInfoState extends Equatable {
  final SettingsInfoModel? settingsInfo;

  const SettingsInfoState({this.settingsInfo});

  SettingsInfoState copyWith({SettingsInfoModel? settingsInfo}) =>
      SettingsInfoState(settingsInfo: settingsInfo ?? this.settingsInfo);

  @override
  List<Object?> get props => [settingsInfo];
}
