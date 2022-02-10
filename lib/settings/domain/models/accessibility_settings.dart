import 'package:equatable/equatable.dart';

class AccessibilitySettings extends Equatable {
  const AccessibilitySettings({
    this.voiceCommands = false,
    this.darkMode = false,
    this.zoomLevel = 100,
  });

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      voiceCommands: json['plainText'] as bool,
      darkMode: json['darkMode'] as bool,
      zoomLevel: json['zoomLevel'] as double,
    );
  }
  final bool voiceCommands;
  final bool darkMode;
  final double zoomLevel;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'plainText': voiceCommands,
      'darkMode': darkMode,
      'zoomLevel': zoomLevel,
    };
  }

  @override
  List<Object?> get props => [
        voiceCommands,
        darkMode,
        zoomLevel,
      ];
}
