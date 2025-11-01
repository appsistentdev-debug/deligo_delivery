part of 'app_cubit.dart';

abstract class AppState {}

class Uninitialized extends AppState {}

class Initialized extends AppState {
  final bool isDemoShowLangs;
  Initialized(this.isDemoShowLangs);
}

class Authenticated extends Initialized {
  final bool profileSet;
  Authenticated(super.isDemoShowLangs, this.profileSet);
}

class Unauthenticated extends Initialized {
  final bool? wasLoggedOut;
  Unauthenticated(super.isDemoShowLangs, [this.wasLoggedOut]);
}

class FailureState extends AppState {
  final String msgKey;
  FailureState(this.msgKey);
  @override
  String toString() => 'FailureState(msgKey: $msgKey)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FailureState && other.msgKey == msgKey;
  }

  @override
  int get hashCode => msgKey.hashCode;
}
