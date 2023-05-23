part of './providers.dart';

class AuthProvider with ChangeNotifier {
  AuthStatus _autStatus = AuthStatus.checking;
  LoginModel credentials = LoginModel();

  AuthStatus get autStatus => _autStatus;
  set autStatus(AuthStatus data) {
    _autStatus = data;
    notifyListeners();
  }

  AuthProvider() {
    //autenticated();
  }

  Future<void> autenticated({bool login = false}) async {
    try {
      final TokenResponse validateToken = Storages.getToken;

      if (validateToken.accessToken != null) {
        autStatus = AuthStatus.notAuthenticated;
        final json = await ApiServices.httpPost(
          path: '${Environment.apiUrl}/userinfo',
          data: validateToken.toJson(),
        );
        UserModel userModel = UserModel.fromJson(json);
        if (userModel.email != null) {
          await Storages.setUser(data: userModel);
          autStatus = AuthStatus.authenticated;
          notifyListeners();
          await Future.delayed(Duration.zero).then(
            (value) => Navigator.pushReplacement(
              NavigatonServices.navigatiorKey.currentContext!,
              PageRouteBuilder(transitionDuration: Duration.zero, pageBuilder: (_, __, ___) => const HomePage()),
            ),
          );
          return;
        }
      }

      await ApiServices.httpPost(
        path: '${Environment.apiUrl}/logout',
        data: validateToken.toJson(),
      );

      autStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      if (!login) {
        await Future.delayed(Duration.zero).then(
          (value) => Navigator.pushReplacement(
            NavigatonServices.navigatiorKey.currentContext!,
            PageRouteBuilder(transitionDuration: Duration.zero, pageBuilder: (_, __, ___) => const LoginPage()),
          ),
        );
      }
    } catch (err) {
      debugPrint('isAutenticated err $err');
      autStatus = AuthStatus.notAuthenticated;
      notifyListeners();
    }
  }

  Future<void> onLogin({required BuildContext context}) async {
    final json = await ApiServices.httpPost(
      path: '${Environment.apiUrl}/token',
      data: credentials.toJson(),
    );
    if (json == null) {
      showAlertOK(
        icon: 'assets/svg/ic-error.svg',
        title: 'Error',
        content: 'Verificar Usuario o Contraseña',
      );
      return;
    }
    TokenResponse loginToken = TokenResponse.fromJson(json);
    if (loginToken.accessToken != null && loginToken.refreshToken != null) {
      credentials.password = null;

      if (credentials.remember) {
        await Storages.setCredentials(data: credentials);
      } else {
        await Storages.removeCredentials;
      }

      await Storages.setToken(data: loginToken);
      await autenticated();
    }
  }
}
