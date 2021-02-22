part of 'settings_cubit.dart';

@immutable
abstract class SettingsState {
  const SettingsState();
}

class InitialState extends SettingsState {
  const InitialState() : super();
}

class Loaded extends SettingsState {
  const Loaded() : super();
}
