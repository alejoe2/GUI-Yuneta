import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gui_sfs/src/services/services.dart';
import 'package:gui_sfs/src/ui/ui.dart';
import 'package:gui_sfs/src/wigets/wigets.dart';
import 'src/models/models.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => WSProvier()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
        scrollbars: true,
      ),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool ready = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);
    wsProvier.webSocketListen();
    wsProvier.send(identityToJson(wsProvier.eventIdentity));
  }

  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('YUNETA')),
      drawer: DrawerCustom(eventIdentity: wsProvier.eventIdentity),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Column(
            children: [
              if (wsProvier.realm.event != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.blueAccent,
                  height: 100,
                  width: double.infinity,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: wsProvier.realm.kw!.data.length,
                      itemBuilder: (_, i) {
                        String icon = '';
                        icon = selectIcon(wsProvier.realm.kw!.data[i]['id']);
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              width: 150,
                              height: 55,
                              child: CardButton(
                                backColor: (wsProvier.realmSelect ==
                                        wsProvier.realm.kw!.data[i]['id'])
                                    ? const Color(0xFFFFEB3B)
                                    : Colors.lightBlue,
                                onTapCard: () {
                                  wsProvier.realmSelect =
                                      wsProvier.realm.kw!.data[i]['id'];
                                  wsProvier.realmIconSelect = icon;
                                  wsProvier.send(mtCommandToJson(
                                      wsProvier.setEvMtCommand(
                                          ('1 realm_id=${wsProvier.realm.kw!.data[i]['id']}'))));
                                },
                                srcIcon: (icon != '')
                                    ? icon
                                    : 'assets/svg/ic_real.svg',
                                text:
                                    '${wsProvier.realm.kw!.data[i]['realm_role'] ?? '-'}',
                              ),
                            )
                          ],
                        );
                      }),
                )
              ],
              if (wsProvier.yunos.event != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: wsProvier.yunos.kw!.data.length,
                        itemBuilder: (_, e) {
                          List<dynamic> lists = [];
                          if (wsProvier.yunoRole !=
                              wsProvier.yunos.kw!.data[e]['yuno_role']) {
                            wsProvier.yunoRole =
                                wsProvier.yunos.kw!.data[e]['yuno_role'];
                            lists.clear();
                            for (var l in wsProvier.yunos.kw!.data) {
                              if (l['yuno_role'] == wsProvier.yunoRole) {
                                lists.add(l);
                              }
                            }
                            lists.sort((a, b) => a['yuno_name']
                                .toString()
                                .compareTo(b['yuno_name'].toString()));
                          }

                          return Column(
                            children: [
                              if (lists.isNotEmpty) ...[
                                Text(
                                  wsProvier.yunoRole,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 130,
                                  color: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: lists.length,
                                      itemBuilder: (_, i) {
                                        String icon = '';
                                        icon = selectIcon(
                                            lists[i]['realm_id'].first);
                                        return Container(
                                          width: 150,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: CardButton(
                                            backColor: const Color(0xFFFFFFFF),
                                            borderColor: Colors.blueAccent,
                                            stateYuno: lists[i]['yuno_running'],
                                            onTapCard: () async {},
                                            onTapInfo: () async {
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomDialogBox(
                                                      icon: (icon != '')
                                                          ? icon
                                                          : 'assets/svg/ic_yuno.svg',
                                                      yunoId: lists[i]['id'],
                                                      text: 'Boton',
                                                      title:
                                                          '${lists[i]['yuno_role'] ?? '-'}: ${lists[i]['yuno_name'] ?? '-'}',
                                                    );
                                                  });
                                              /*
                                              Timer.periodic(const Duration(milliseconds: 1000), (Timer t) async {
                                                if (wsProvier.infoGclassTrace.kw!.data != null &&
                                                    wsProvier.getGclassTrace.kw!.data != null) {
                                                  t.cancel();
                                                }
                                              });
                                              */
                                            },
                                            infoIcon: (lists[i]['yuno_running'])
                                                ? 'assets/svg/ic_info.svg'
                                                : null,
                                            srcIcon: (icon != '')
                                                ? icon
                                                : 'assets/svg/ic_yuno.svg',
                                            text:
                                                '${lists[i]['yuno_name'] ?? '-'}\n${lists[i]['yuno_role'] ?? '-'}\n${lists[i]['yuno_release'] ?? '-'}',
                                          ),
                                        );
                                      }),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                )
                              ]
                            ],
                          );
                        }),
                  ),
                ),
            ],
          ))
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String selectIcon(String data) {
    switch (data) {
      case 'sfs.utils.com':
        return 'assets/svg/ic_utils.svg';

      case 'sfs.backend.com':
        return 'assets/svg/ic_backend.svg';

      case 'sfs.gate-gps.com':
        return 'assets/svg/ic_gps.svg';

      case 'sfs.gate-video.com':
        return 'assets/svg/ic_video.svg';

      default:
        return '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
