part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

/// VERIFICATION STATES START
class VerificationLoading extends AuthState {
  const VerificationLoading();
}

class VerificationLoaded extends AuthState {
  const VerificationLoaded();
}

class VerificationSendingLoading extends VerificationLoading {
  const VerificationSendingLoading();
}

class VerificationVerifyingLoading extends VerificationLoading {
  const VerificationVerifyingLoading();
}

class VerificationSentLoaded extends VerificationLoaded {
  VerificationSentLoaded();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationSentLoaded && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class VerificationVerifyingLoaded extends VerificationLoaded {
  final AuthResponse authResponse;

  VerificationVerifyingLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationVerifyingLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class VerificationError extends AuthState {
  final String message, messageKey;

  const VerificationError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}

/// VERIFICATION STATES START

/// REGISTER STATES START
class RegisterLoading extends AuthState {
  const RegisterLoading();
}

class RegisterLoaded extends AuthState {
  final AuthResponse authResponse;

  const RegisterLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class RegisterError extends AuthState {
  final String message, messageKey;

  const RegisterError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}

/// REGISTER STATES END

/// LOGIN STATES START

class LoginLoading extends AuthState {
  const LoginLoading();
}

class LoginExistsLoaded extends AuthState {
  final bool isRegistered;
  final PhoneNumberData phoneNumberData;

  const LoginExistsLoaded(this.isRegistered, this.phoneNumberData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginExistsLoaded &&
          runtimeType == other.runtimeType &&
          isRegistered == other.isRegistered &&
          phoneNumberData == other.phoneNumberData;

  @override
  int get hashCode => isRegistered.hashCode ^ phoneNumberData.hashCode;
}

class LoginLoaded extends AuthState {
  final AuthResponse authResponse;

  const LoginLoaded(this.authResponse);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginLoaded &&
          runtimeType == other.runtimeType &&
          authResponse == other.authResponse;

  @override
  int get hashCode => authResponse.hashCode;
}

class LoginError extends AuthState {
  final String message, messageKey;

  const LoginError(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginError &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;

  @override
  String toString() => 'LoginError(message: $message)';
}

class LoginErrorSocial extends LoginError {
  String? loginName, loginEmail, loginImageUrl;

  LoginErrorSocial(this.loginName, this.loginEmail, this.loginImageUrl,
      String message, String messageKey)
      : super(message, messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is LoginErrorSocial &&
          runtimeType == other.runtimeType &&
          loginName == other.loginName &&
          loginEmail == other.loginEmail &&
          loginImageUrl == other.loginImageUrl;

  @override
  int get hashCode =>
      super.hashCode ^
      loginName.hashCode ^
      loginEmail.hashCode ^
      loginImageUrl.hashCode;
}

/// LOGIN STATES END