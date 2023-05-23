import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gui_sfs/src/helpers/helpers.dart';
import 'package:gui_sfs/src/pages/pages.dart';
import 'package:gui_sfs/src/services/services.dart';
import 'package:provider/provider.dart';
import 'src/providers/providers.dart';

void main() => runApp(const States());

class States extends StatefulWidget {
  const States({super.key});

  @override
  State<States> createState() => _StatesState();
}

class _StatesState extends State<States> {
  bool ready = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await LocalStorage.configPrefs();
    ready = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeServices()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WSProvier()),
      ],
      child: (ready) ? const MyApp() : Container(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
        scrollbars: true,
      ),
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode || supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      navigatorKey: NavigatonServices.navigatiorKey,
      initialRoute: RouterPages.splash.name,
    );
  }
}
