part of './../pages/pages.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  RouterPages.splash.name: (_) => const SplashScreenPage(),
  RouterPages.home.name: (_) => const HomePage(),
  RouterPages.login.name: (_) => const LoginPage(),
  RouterPages.realms.name: (_) => const RealmsPage(),
  RouterPages.yunos.name: (_) => const YunoPages(),
  RouterPages.summary.name: (_) => const SymmaryPage(),
};
