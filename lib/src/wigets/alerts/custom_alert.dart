part of '../wigets.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, text, icon, yunoId, yunoRole;

  const CustomDialogBox({
    Key? key,
    this.title,
    this.yunoRole,
    this.text,
    this.icon,
    this.yunoId,
  }) : super(key: key);

  @override
  CustomDialogBoxState createState() => CustomDialogBoxState();
}

class CustomDialogBoxState extends State<CustomDialogBox> {
  String? menuOpen;
  List<Receiverlog?> receiverlog = [];
  List<Receiverlog?> receiverlogShow = [];
  final ScrollController _controllerTextLog = ScrollController();
  TextEditingController findController = TextEditingController();
  TextEditingController filterController = TextEditingController();
  UDP? receiver;
  String data = '';
  String frame = '';
  String? publicIp;
  String? localIP;
  int port = 9999;
  String gclass = '';

  bool ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);
    wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId} service=__root__ command=view-attrs')));
    wsProvier.infoGclassTrace.kw = null;
    wsProvier.getGclassTrace.kw = null;
    wsProvier.addLogHandler = false;
    wsProvier.setGclassTrace = false;
    menuOpen = null;
    receiverlog.clear();
    receiverlogShow.clear();
    ready = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: (ready)
          ? contentBox(context)
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  Future<void> dispose() async {
    _controllerTextLog.dispose();
    findController.dispose();
    receiver?.close();
    super.dispose();
  }

  contentBox(context) {
    final wsProvier = Provider.of<WSProvier>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 20, top: 50, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                (wsProvier.getAttrs.kw?.data['GpsModel'] != null) ? wsProvier.getAttrs.kw!.data['GpsModel'] : '',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    icSetTraces(wsProvier),
                    icViewLog(wsProvier),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (menuOpen == 'items_logs') traceLogs(wsProvier),
              if (menuOpen == 'log') ...viewLogs(wsProvier),
              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          height: 50,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 5,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: SvgPicture.asset(
                widget.icon!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: SizedBox(
            height: 40,
            width: 40,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                size: 35,
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InkWell icViewLog(WSProvier wsProvier) {
    return InkWell(
      onTap: () async {
        menuOpen = 'log';
        setState(() {});
        publicIp = await getPublicIp();
        print(publicIp);
        localIP = await getLocalIpAddress();
        print(localIP);

        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId}  service=__root__ command=info-gclass-trace')));

        await Future.delayed(const Duration(milliseconds: 300));

        wsProvier.infoGclassTrace.kw!.data.forEach((value) {
          if (value['gclass'].toString().toUpperCase().contains('DECODER')) {
            gclass = value['gclass'].toString();
          }
        });

        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId} service=__yuno__ command=get-trace-filter gclass=$gclass')));

        await Future.delayed(const Duration(milliseconds: 300));

        if (wsProvier.getTraceFilter.kw!.data != null) {
          filterController.text = wsProvier.getTraceFilter.kw!.data['GpsId'][0].toString();
        }

        List<String> getYunoList = Storages.getYunoList;
        for (var yuno in getYunoList) {
          wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=$yuno service=__yuno__ command=delete-log-handler name=${Storages.getUser.email!.split('@')[0]}')));
          await Future.delayed(const Duration(milliseconds: 100));
        }
        getYunoList.clear();

        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId} service=__yuno__ command=add-log-handler name=${Storages.getUser.email!.split('@')[0]} type=udp url=udp://$publicIp:$port')));

        getYunoList.add(widget.yunoId!);
        await Storages.setYunoList(data: getYunoList);

        await Future.delayed(const Duration(milliseconds: 500));

        var multicastEndpoint = Endpoint.unicast(InternetAddress(localIP!), port: Port(port));
        receiver = await UDP.bind(multicastEndpoint);
        receiver!.asStream(timeout: const Duration(seconds: 10000)).listen((datagram) {
          data = String.fromCharCodes(datagram!.data).replaceAll("ð´", '🔴').replaceAll("ðµ", '🔵');
          int len = data.length;
          int w = 0;

          do {
            String c = data[w];
            if (c.codeUnitAt(0) == 0) {
              String crcIn = frame.substring(frame.length - 8, frame.length).toUpperCase();
              frame = frame.substring(0, frame.length - 8);
              int crc = 0;
              for (int x = 0; x < frame.length; x++) {
                crc += frame.codeUnitAt(x);
              }
              if (frame.contains('🔵') || frame.contains('🔴')) {
                crc -= 112282;
              }
              if (crc.toRadixString(16).padLeft(8, '0').toUpperCase() == crcIn) {
                // print('CRC OK');
              } else {
                //print('CRC BAD');
                //print(data.toString());
                /*print(crc.toRadixString(16).padLeft(8, '0').toUpperCase());
                print(crcIn);
                
                print(frame);*/
              }
              String typeLog = getTypeLog(frame.substring(0, 1), false);
              String icon = getTypeLog(frame.substring(0, 1), true);
              receiverlog.add(Receiverlog(
                icon: icon,
                type: typeLog,
                data: frame.substring(9, frame.length),
              ));
              if (receiverlog.length > 500) {
                receiverlog.removeAt(0);
              }
              frame = '';
            } else {
              frame += c;
            }
            w++;
          } while (w < len);
          if (mounted) search(findController.text);
        });
      },
      child: SvgPicture.asset(
        'assets/svg/ic_logs.svg',
        fit: BoxFit.contain,
        height: 30,
        width: 30,
      ),
    );
  }

  InkWell icSetTraces(WSProvier wsProvier) {
    return InkWell(
      onTap: () {
        wsProvier.infoGclassTrace.kw = null;
        wsProvier.getGclassTrace.kw = null;
        menuOpen = 'items_logs';
        setState(() {});
        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId}  service=__root__ command=info-gclass-trace')));
        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId}  service=__root__ command=get-gclass-trace')));
      },
      child: SvgPicture.asset(
        'assets/svg/ic_items.svg',
        fit: BoxFit.contain,
        width: 30,
        height: 30,
      ),
    );
  }

  List<Widget> viewLogs(WSProvier wsProvier) {
    return (!wsProvier.addLogHandler && !wsProvier.setGclassTrace)
        ? [
            const Center(
              child: CircularProgressIndicator(),
            )
          ]
        : [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 10,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: TextField(
                      controller: findController,
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        search(value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: filterController,
                            onSubmitted: (value) {
                              sendFilter(wsProvier);
                            },
                            decoration: InputDecoration(
                              hintText: 'Filtrar ID',
                              suffixIcon: InkWell(
                                onTap: () async => sendFilter(wsProvier),
                                child: Icon(
                                  (wsProvier.getTraceFilter.kw?.data == null) ? Icons.send : Icons.delete,
                                  color: (wsProvier.getTraceFilter.kw?.data == null) ? Colors.blue : Colors.red,
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.filter_alt,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: (wsProvier.getTraceFilter.kw!.data == null) ? Colors.white : Colors.grey[350],
                            ),
                            readOnly: (wsProvier.getTraceFilter.kw!.data == null) ? false : true,
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  InkWell(
                    child: Container(
                      width: 45,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/svg/ic_trash.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    onTap: () {
                      receiverlog = [];
                      search(findController.text);
                    },
                  ),
              ]),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.blueGrey,
                    width: 10,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: RawScrollbar(
                  thumbVisibility: true,
                  controller: _controllerTextLog,
                  thumbColor: Colors.redAccent,
                  radius: const Radius.circular(20),
                  thickness: 15,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: receiverlogShow.length,
                    controller: _controllerTextLog,
                    itemBuilder: (_, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              height: 20,
                              width: 25,
                              child: SvgPicture.asset(
                                receiverlogShow[index]!.icon!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Expanded(
                              child: SelectableText((receiverlogShow[index]!.type ?? '') + (receiverlogShow[index]!.data ?? ''), style: GoogleFonts.robotoMono(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ];
  }

  void sendFilter(WSProvier wsProvier) async {
    wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId} service=__yuno__ command=set-trace-filter gclass=$gclass value=${filterController.text} attr=GpsId set=${(wsProvier.getTraceFilter.kw!.data == null) ? '1' : '0'}')));

    wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand('command-yuno id=${widget.yunoId} service=__yuno__ command=get-trace-filter gclass=$gclass')));

    await Future.delayed(const Duration(milliseconds: 300));

    if (wsProvier.getTraceFilter.kw!.data != null) {
      filterController.text = wsProvier.getTraceFilter.kw!.data['GpsId'][0].toString();
    } else {
      filterController.text = '';
    }

    setState(() {});
  }

  String getTypeLog(String data, bool icon) {
    switch (data) {
      case '0':
        return (icon) ? 'assets/svg/ic-emerg.svg' : 'EMERG: ';
      case '1':
        return (icon) ? 'assets/svg/ic-alert.svg' : 'ALERT: ';
      case '2':
        return (icon) ? 'assets/svg/ic-crit.svg' : 'CRIT: ';
      case '3':
        return (icon) ? 'assets/svg/ic-error.svg' : 'ERROR: ';
      case '4':
        return (icon) ? 'assets/svg/ic-warning.svg' : 'WARNING: ';
      case '5':
        return (icon) ? 'assets/svg/ic-notice.svg' : 'NOTICE: ';
      case '6':
        return (icon) ? 'assets/svg/ic-info.svg' : 'INFO: ';
      case '7':
        return (icon) ? 'assets/svg/ic-debug.svg' : 'DEBUG: ';
      default:
        return (icon) ? 'assets/svg/ic-info.svg' : 'INFO: ';
    }
  }

  Expanded traceLogs(WSProvier wsProvier) {
    return Expanded(
      child: (wsProvier.infoGclassTrace.kw == null && wsProvier.getGclassTrace.kw == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: wsProvier.infoGclassTrace.kw!.data.length,
              itemBuilder: (_, i) {
                if (wsProvier.infoGclassTrace.kw!.data[i]['gclass'].toString().toUpperCase().contains(widget.yunoRole!.toUpperCase())) {
                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wsProvier.infoGclassTrace.kw!.data[i]['gclass'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...wsProvier.infoGclassTrace.kw!.data[i]['trace_levels'].keys.map((t) {
                            bool state = false;
                            for (var traceT in wsProvier.getGclassTrace.kw!.data) {
                              if (traceT['gclass'] == wsProvier.infoGclassTrace.kw!.data[i]['gclass']) {
                                for (var traceL in traceT['trace_levels']) {
                                  if (t == traceL) {
                                    state = true;
                                  }
                                }
                              }
                            }

                            return Row(
                              children: [
                                Text(t.toString()),
                                const SizedBox(width: 5),
                                Switch(
                                    value: state,
                                    onChanged: (value) {
                                      String command = 'command-yuno id=${widget.yunoId} service=__root__ command=set-gclass-trace gclass=${wsProvier.infoGclassTrace.kw!.data[i]['gclass']} level=$t set=${(value) ? 1 : 0}';
                                      wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(command)));

                                      bool addTraceT = false;
                                      for (var traceT in wsProvier.getGclassTrace.kw!.data) {
                                        if (traceT['gclass'] == wsProvier.infoGclassTrace.kw!.data[i]['gclass']) {
                                          addTraceT = true;
                                          if (value) {
                                            traceT['trace_levels'].add(t);
                                          } else {
                                            traceT['trace_levels'].remove(t);
                                          }
                                        }
                                      }
                                      if (!addTraceT) {
                                        wsProvier.getGclassTrace.kw!.data.add({
                                          "gclass": wsProvier.infoGclassTrace.kw!.data[i]['gclass'],
                                          "trace_levels": [t]
                                        });
                                      }
                                      setState(() {});
                                    })
                              ],
                            );
                          }).toList(),
                        ],
                      ));
                } else {
                  return Container();
                }
              },
            ),
    );
  }

  search(String value) {
    if (value.isNotEmpty) {
      List<Receiverlog> items = [];
      List<Receiverlog> dummyListData = [];
      for (var element in receiverlog) {
        if (element!.data!.toUpperCase().contains(value.toUpperCase())) {
          dummyListData.add(element);
        }
      }
      items.clear();
      items.addAll(dummyListData);
      receiverlogShow = items;
      setState(() {});
      return;
    } else {
      receiverlogShow = receiverlog;
      setState(() {});
    }
  }

  static Future<String?> getLocalIpAddress() async {
    final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: true);

    try {
      // Try VPN connection first
      NetworkInterface vpnInterface = interfaces.firstWhere((element) => element.name == "tun0");
      return vpnInterface.addresses.first.address;
    } on StateError {
      // Try wlan connection next
      try {
        NetworkInterface interface = interfaces.firstWhere((element) => element.name == "wlan0");
        return interface.addresses.first.address;
      } catch (ex) {
        // Try any other connection next
        try {
          NetworkInterface interface = interfaces.firstWhere((element) => !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }
}
