import 'package:fludget/core/ui/tokens.dart';
import 'package:flutter/material.dart';

/// App-wide editor settings. For now just the simulated device frame the canvas
/// previews inside; defaults to the standard phone size from the tokens.
@immutable
class SettingsState {
  const SettingsState({
    this.deviceWidth = DeviceFrame.width,
    this.deviceHeight = DeviceFrame.height,
  });

  final double deviceWidth;
  final double deviceHeight;

  SettingsState copyWith({double? deviceWidth, double? deviceHeight}) =>
      SettingsState(
        deviceWidth: deviceWidth ?? this.deviceWidth,
        deviceHeight: deviceHeight ?? this.deviceHeight,
      );
}
