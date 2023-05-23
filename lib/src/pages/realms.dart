part of './pages.dart';

class RealmsPage extends StatefulWidget {
  const RealmsPage({super.key});

  @override
  State<RealmsPage> createState() => _RealmsPageState();
}

class _RealmsPageState extends State<RealmsPage> {
  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);

    return Scaffold(
      appBar: customAppBar(context: context, title: 'REINOS'),
      drawer: DrawerCustom(eventIdentity: wsProvier.eventIdentity),
      body: (wsProvier.realm.event == null)
          ? Container()
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  color: TColors.seconRed,
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 150,
                            height: 55,
                            child: CardButton(
                              backColor: (wsProvier.realmSelect == wsProvier.realm.kw!.data[i]['id']) ? TColors.priRed : Colors.white.withOpacity(0.8),
                              onTapCard: () {
                                wsProvier.realmSelect = wsProvier.realm.kw!.data[i]['id'];
                                wsProvier.realmIconSelect = icon;
                                wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(('1 realm_id=${wsProvier.realm.kw!.data[i]['id']}'))));
                              },
                              srcIcon: (icon != '') ? icon : 'assets/svg/ic_real.svg',
                              text: '${wsProvier.realm.kw!.data[i]['realm_role'] ?? '-'}',
                              textColor: (wsProvier.realmSelect == wsProvier.realm.kw!.data[i]['id']) ? TColors.priWithe : TColors.priRed,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                (wsProvier.yunos.event == null) ? Container() : Expanded(child: listYunos(wsProvier, context)),
              ],
            ),
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
}
