part of '../wigets.dart';

Widget listYunos(WSProvier wsProvier, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: wsProvier.yunos.kw!.data.length,
      itemBuilder: (_, e) {
        List<dynamic> lists = [];
        if (wsProvier.yunoRole != wsProvier.yunos.kw!.data[e]['yuno_role']) {
          wsProvier.yunoRole = wsProvier.yunos.kw!.data[e]['yuno_role'];
          lists.clear();
          for (var l in wsProvier.yunos.kw!.data) {
            if (l['yuno_role'] == wsProvier.yunoRole) {
              lists.add(l);
            }
          }
          lists.sort((a, b) => a['yuno_name'].toString().compareTo(b['yuno_name'].toString()));
        }

        return Column(
          children: [
            if (lists.isNotEmpty) ...[
              Text(
                wsProvier.yunoRole,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 135,
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: lists.length,
                    itemBuilder: (_, i) {
                      String icon = '';
                      icon = selectIcon(lists[i]['realm_id'].first);
                      return FadeInRight(
                        child: Container(
                          width: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: CardButton(
                            backColor: const Color(0xFFFFFFFF),
                            borderColor: Colors.blueAccent.withOpacity(0.5),
                            stateYuno: lists[i]['yuno_running'],
                            onTapCard: () async {},
                            onTapInfo: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomDialogBox(
                                      icon: (icon != '') ? icon : 'assets/svg/ic_yuno.svg',
                                      yunoId: lists[i]['id'],
                                      text: 'Boton',
                                      yunoRole: lists[i]['yuno_role'] ?? '-',
                                      title: '${lists[i]['yuno_role'] ?? '-'}: ${lists[i]['yuno_name'] ?? '-'}',
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
                            infoIcon: (lists[i]['yuno_running']) ? 'assets/svg/ic_info.svg' : null,
                            srcIcon: (icon != '') ? icon : 'assets/svg/ic_yuno.svg',
                            text: '${lists[i]['yuno_name'] ?? '-'}\n${lists[i]['yuno_role'] ?? '-'}\n${lists[i]['yuno_release'] ?? '-'}',
                          ),
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
      },
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
