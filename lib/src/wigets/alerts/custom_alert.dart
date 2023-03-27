part of '../wigets.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, text, icon, yunoId;

  const CustomDialogBox({
    Key? key,
    this.title,
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
  UDP? receiver;
  String data = '';
  String frame = '';
  String? publicIp;
  String? localIP;
  int port = 9999;

  bool ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);
    wsProvier.infoGclassTrace.event = null;
    wsProvier.getGclassTrace.event = null;
    wsProvier.addLogHandler = false;
    wsProvier.setGclassTrace = false;

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
  void dispose() {
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
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 30,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        menuOpen = 'items_logs';
                        setState(() {});
                        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(
                            'command-yuno id=${widget.yunoId}  service=__root__ command=info-gclass-trace')));
                        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(
                            'command-yuno id=${widget.yunoId}  service=__root__ command=get-gclass-trace')));
                      },
                      child: SvgPicture.asset(
                        'assets/svg/ic_items.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        publicIp = await getPublicIp();
                        print(publicIp);
                        localIP = await getLocalIpAddress();
                        print(localIP);
                        menuOpen = 'log';
                        setState(() {});

                        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(
                            'command-yuno id=${widget.yunoId} service=__yuno__ command=delete-log-handler name=test1')));

                        wsProvier.send(mtCommandToJson(wsProvier.setEvMtCommand(
                            'command-yuno id=${widget.yunoId} service=__yuno__ command=add-log-handler name=test1 type=udp url=udp://$publicIp:$port')));

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
                                print('CRC OK');
                              } else {
                                print(crc.toRadixString(16).padLeft(8, '0').toUpperCase());
                                print(crcIn);
                                print('CRC BAD');
                                print(frame);
                              }
                              String typeLog = getTypeLog(frame.substring(0, 1), false);
                              String icon = getTypeLog(frame.substring(0, 1), true);
                              receiverlog.add(Receiverlog(
                                icon: icon,
                                type: typeLog,
                                data: frame.substring(9, frame.length),
                              ));
                              frame = '';
                            } else {
                              frame += c;
                            }
                            w++;
                          } while (w < len);
                          search(findController.text);
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/svg/ic_logs.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (menuOpen == 'items_logs') traceLogs(wsProvier),
              if (menuOpen == 'log') ...logs(wsProvier),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text!,
                      style: const TextStyle(fontSize: 18),
                    )),
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
      ],
    );
  }

  List<Widget> logs(WSProvier wsProvier) {
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
                      width: 250,
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
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (value) {
                          search(value);
                        },
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
                  thickness: 5,
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
                              child: SelectableText(
                                  (receiverlogShow[index]!.type ?? '') + (receiverlogShow[index]!.data ?? ''),
                                  style: GoogleFonts.robotoMono(color: Colors.white)),
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
        return '';
    }
  }

  Expanded traceLogs(WSProvier wsProvier) {
    return Expanded(
      child: (wsProvier.infoGclassTrace.event == null && wsProvier.getGclassTrace.event == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: wsProvier.infoGclassTrace.kw!.data.length,
              itemBuilder: (_, i) {
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
                                    String command =
                                        'command-yuno id=${widget.yunoId} service=__root__ command=set-gclass-trace gclass=${wsProvier.infoGclassTrace.kw!.data[i]['gclass']} level=$t set=${(value) ? 1 : 0}';
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
          NetworkInterface interface =
              interfaces.firstWhere((element) => !(element.name == "tun0" || element.name == "wlan0"));
          return interface.addresses.first.address;
        } catch (ex) {
          return null;
        }
      }
    }
  }
}
