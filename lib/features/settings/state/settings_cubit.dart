import 'package:fludget/features/settings/state/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the app-wide settings. In memory for now; the canvas watches it, so a
/// change re-sizes the preview frame immediately.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setDeviceWidth(double value) => emit(state.copyWith(deviceWidth: value));
  void setDeviceHeight(double value) =>
      emit(state.copyWith(deviceHeight: value));
}
