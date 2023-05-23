part of './services.dart';

class ThemeServices with ChangeNotifier {
  bool _themeLight = true;
  late ThemeSelect _theme;

  bool get getThemeLight => _themeLight;

  ThemeSelect get theme => _theme;

  static late BuildContext _context;

  set context(BuildContext data) {
    _context = data;
  }

  void validateTheme({required BuildContext context}) async {
    _theme = Storages.getTheme;

    _context = context;

    switch (_theme) {
      case ThemeSelect.auto:
        await Future.delayed(const Duration(milliseconds: 300));
        final Brightness brightnessValue = await Future.delayed(Duration.zero).then((value) => MediaQuery.of(_context).platformBrightness);
        final isLight = brightnessValue == Brightness.light;
        _themeLight = isLight;
        break;
      case ThemeSelect.dark:
        _themeLight = false;
        break;
      default:
        _themeLight = true;
        break;
    }

    notifyListeners();
  }

  void setTheme({required ThemeSelect data}) async {
    await Storages.setTheme(data: data);
    await Future.delayed(Duration.zero).then((value) => validateTheme(context: _context));
  }
}
