part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoaded extends SettingsState {
  final String apiUrl;
  final String? companyName;

  SettingsLoaded({
    required this.apiUrl,
    this.companyName,
  });
}

final class SettingsPasswordLoaded extends SettingsState {
  final bool savePassword;

  SettingsPasswordLoaded({
    required this.savePassword,
  });
}

final class SettingsSaved extends SettingsState {}
