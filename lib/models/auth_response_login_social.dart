import 'auth_response.dart';

class AuthResponseSocial {
  String? userName, userEmail, userImageUrl;
  AuthResponse? authResponse;

  AuthResponseSocial(
      this.userName, this.userEmail, this.userImageUrl, this.authResponse);

  @override
  String toString() =>
      'AuthResponseSocial(userName: $userName, userEmail: $userEmail, userImageUrl: $userImageUrl)';
}
