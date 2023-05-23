class Environment {
  static bool isProduction = const bool.fromEnvironment('dart.vm.product');

  static String get apiUrl {
    if (isProduction) {
      return 'https://sfs.yunetacontrol.ovh:8641/auth/realms/sfs/protocol/openid-connect'; // production
    }
    return 'https://sfs.yunetacontrol.ovh:8641/auth/realms/sfs/protocol/openid-connect';
  }
}
