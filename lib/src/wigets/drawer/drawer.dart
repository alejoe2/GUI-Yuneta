part of '../wigets.dart';

class DrawerCustom extends StatelessWidget {
  final Identity eventIdentity;
  const DrawerCustom({
    super.key,
    required this.eventIdentity,
  });

  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);
    return SizedBox(
      width: 150,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: TColors.priRed,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'YUNETA',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SvgPicture.asset(
                    'assets/svg/ic_yuno.svg',
                    fit: BoxFit.contain,
                    width: 60,
                    height: 60,
                  ),
                ],
              ),
            ),
            botonMenu(
              icon: 'assets/svg/ic_nodos.svg',
              context: context,
              routeName: RouterPages.home.name,
            ),
            if (wsProvier.server != '') ...[
              botonMenu(
                icon: 'assets/svg/ic_realm.svg',
                command: '4',
                context: context,
                routeName: RouterPages.realms.name,
              ),
              botonMenu(
                icon: 'assets/svg/ic_yuno.svg',
                command: '1',
                context: context,
                routeName: RouterPages.yunos.name,
              ),
              botonMenu(
                icon: 'assets/svg/ic_summary.svg',
                command: 'command-yuno yuno_role=logcenter command=display-summary',
                context: context,
                routeName: RouterPages.summary.name,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget botonMenu({
    required String icon,
    String? command,
    required BuildContext context,
    required String routeName,
  }) {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: 60,
      child: CardButton(
        backColor: (Storages.getSelectedMenuDrawer == routeName) ? TColors.priRed : TColors.priWithe,
        borderColor: TColors.seconRed,
        onTapCard: () {
          if (command != null) wsProvier.send(mtCommandToJson(setEvMtCommand(command)));
          Navigator.pushReplacementNamed(context, routeName);
          Storages.setSelectMenuDrawer(data: routeName);
        },
        srcIcon: icon,
        text: '',
      ),
    );
  }

  MtCommand setEvMtCommand(String command) {
    return MtCommand(
      event: "EV_MT_COMMAND",
      command: command,
      kw: KwCommand(
        command: command,
        temp: eventIdentity.kw!.temp,
        mdIev: MdIevCommand(command: [
          command
        ], ieventGateStack: [
          IeventGateStack(
            dstRole: eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstRole,
            dstService: eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstService,
            dstYuno: eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstYuno,
            host: eventIdentity.kw!.mdIev!.ieventGateStack!.first.host,
            srcRole: eventIdentity.kw!.mdIev!.ieventGateStack!.first.srcRole,
            srcService: "cli",
            srcYuno: eventIdentity.kw!.mdIev!.ieventGateStack!.first.srcYuno,
            user: eventIdentity.kw!.mdIev!.ieventGateStack!.first.user,
          )
        ]),
      ),
    );
  }
}
