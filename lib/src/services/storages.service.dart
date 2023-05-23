part of './services.dart';

class Storages {
  static Future<bool> setTheme({required ThemeSelect data}) async => await LocalStorage.prefs.setString(StorageUbication.theme.name, data.name);

  static ThemeSelect get getTheme {
    if (LocalStorage.prefs.getString(StorageUbication.theme.name) != null) {
      final i = ThemeSelect.values.indexWhere((element) => element.name.contains(LocalStorage.prefs.getString(StorageUbication.theme.name)!));

      return ThemeSelect.values[i];
    }
    return ThemeSelect.light;
  }

  static Future<bool> setLoadPermissions({required bool data}) async => await LocalStorage.prefs.setBool(StorageUbication.loadPermission.name, data);

  static Future<bool> get getLoadPermissions async => LocalStorage.prefs.getBool(StorageUbication.loadPermission.name) ?? false;

  static Future<bool> setCredentials({required LoginModel data}) async => LocalStorage.prefs.setString(StorageUbication.credentials.name, logingModelToJson(data));

  static LoginModel get getCredentials => LocalStorage.prefs.getString(StorageUbication.credentials.name) != null ? logingModelFromJson(LocalStorage.prefs.getString(StorageUbication.credentials.name)!) : LoginModel();

  static Future<bool> get removeCredentials async => await LocalStorage.prefs.remove(StorageUbication.credentials.name);

  static Future<bool> setToken({required TokenResponse data}) async => LocalStorage.prefs.setString(StorageUbication.jwt.name, tokenResponseToJson(data));

  static TokenResponse get getToken => LocalStorage.prefs.getString(StorageUbication.jwt.name) != null ? tokenResponseFromJson(LocalStorage.prefs.getString(StorageUbication.jwt.name)!) : TokenResponse();

  static Future<bool> get removeToken async => await LocalStorage.prefs.remove(StorageUbication.jwt.name);

  static Future<bool> setUser({required UserModel data}) async => LocalStorage.prefs.setString(StorageUbication.user.name, userModelToJson(data));

  static UserModel get getUser => LocalStorage.prefs.getString(StorageUbication.user.name) != null ? userModelFromJson(LocalStorage.prefs.getString(StorageUbication.user.name)!) : UserModel();

  static Future<bool> get removeUser async => await LocalStorage.prefs.remove(StorageUbication.user.name);

  static Future<bool> setYunoList({required List<String> data}) async => LocalStorage.prefs.setStringList(StorageUbication.yunoList.name, data);

  static List<String> get getYunoList => LocalStorage.prefs.getStringList(StorageUbication.yunoList.name) != null ? LocalStorage.prefs.getStringList(StorageUbication.yunoList.name)! : [];

  static Future<bool> get removeYunoList async => await LocalStorage.prefs.remove(StorageUbication.yunoList.name);
}
