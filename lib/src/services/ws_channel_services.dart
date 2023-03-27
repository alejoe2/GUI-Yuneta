part of './services.dart';

class WSProvier with ChangeNotifier {
  bool addLogHandler = false;
  bool setGclassTrace = false;

  RespCommand _respCommand = RespCommand();
  RespCommand get respCommand => _respCommand;
  set respCommand(RespCommand data) {
    _respCommand = data;
    notifyListeners();
  }

  RespCommand _realm = RespCommand();
  RespCommand get realm => _realm;
  set realm(RespCommand data) {
    _realm = data;
    notifyListeners();
  }

  RespCommand _yunos = RespCommand();
  RespCommand get yunos => _yunos;
  set yunos(RespCommand data) {
    _yunos = data;
    notifyListeners();
  }

  RespCommand _infoGclassTrace = RespCommand();
  RespCommand get infoGclassTrace => _infoGclassTrace;
  set infoGclassTrace(RespCommand data) {
    _infoGclassTrace = data;
    notifyListeners();
  }

  RespCommand _getGclassTrace = RespCommand();
  RespCommand get getGclassTrace => _getGclassTrace;
  set getGclassTrace(RespCommand data) {
    _getGclassTrace = data;
    notifyListeners();
  }

  String _realmSelect = '';
  String get realmSelect => _realmSelect;
  set realmSelect(String data) {
    _realmSelect = data;
    notifyListeners();
  }

  String _realmIconSelect = '';
  String get realmIconSelect => _realmIconSelect;
  set realmIconSelect(String data) {
    _realmIconSelect = data;
    notifyListeners();
  }

  String _yunoRole = '';
  String get yunoRole => _yunoRole;
  set yunoRole(String data) {
    _yunoRole = data;
  }

  final WebSocketChannel _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:1991'));

  void send(String data) {
    _channel.sink.add(data);
    //print('send: $data');
  }

  Identity eventIdentity = Identity(
    event: "EV_IDENTITY_CARD",
    kw: Kw(
        yunoRole: "yuneta_cli",
        yunoId: "",
        yunoName: "",
        yunoTag: "",
        yunoVersion: "6.3.6",
        yunoRelease: "",
        yunetaVersion: "6.3.6",
        playing: false,
        pid: 7949,
        watcherPid: 0,
        jwt: "",
        username: "yuneta",
        launchId: 0,
        yunoStartdate: "2023-03-16T16:43:23.689088869+0100",
        id: "8ac4d42f-5e1f-48d6-818c-6ac39cbba3e4",
        requiredServices: [],
        mdIev: MdIev(ieventGateStack: [
          IeventGateStack(
              dstYuno: "",
              dstRole: "yuneta_agent",
              dstService: "agent",
              srcYuno: "",
              srcRole: "yuneta_cli",
              srcService: "ws://127.0.0.1:1991-1",
              user: "yuneta",
              host: "luis-laptop")
        ])),
  );

  webSocketListen() {
    _channel.stream.listen(_onDataReceived);
  }

  void _onDataReceived(dynamic data) {
    message = data;
  }

  set message(dynamic data) {
    //print(data.toString());
    dynamic message = jsonDecode(data);

    if (message['kw']['result'] == 0) {
      if (message['event'] == "EV_IDENTITY_CARD_ACK") {
        debugPrint('IDENTITY ACK OK');
        //debugPrint(eventAckFromJson(data).kw!.comment);
      }

      if (message['event'] == "EV_MT_COMMAND_ANSWER") {
        respCommand = respCommandFromJson(data);
        List<String> command = respCommand.kw!.mdIev!.command!.first.toString().split(' ');
        switch (command[0]) {
          case '1':
            if (command.length < 2) {
              realm.event = null;
              realmSelect = '';
            }
            yunoRole = '';
            yunos = respCommand;
            yunos.kw!.data.sort((a, b) => a['yuno_role'].toString().compareTo(b['yuno_role'].toString()));
            break;
          case '4':
            if (command.length < 2) yunos.event = null;
            realm = respCommand;
            break;
          case 'info-gclass-trace':
            infoGclassTrace = respCommand;
            break;
          case 'get-gclass-trace':
            getGclassTrace = respCommand;
            break;
          case 'set-gclass-trace':
            setGclassTrace = true;
            break;
          case 'add-log-handler':
            addLogHandler = true;
            break;
          default:
            print(command[0]);
        }
      }
    } else {
      debugPrint(message['event']);
      debugPrint(message['kw']['comment']);
    }
  }

  MtCommand setEvMtCommand(String command) {
    return MtCommand(
      event: "EV_MT_COMMAND",
      command: command,
      kw: KwCommand(
        command: command,
        temp: WSProvier().eventIdentity.kw!.temp,
        mdIev: MdIevCommand(command: [
          command
        ], ieventGateStack: [
          IeventGateStack(
            dstRole: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstRole,
            dstService: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstService,
            dstYuno: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.dstYuno,
            host: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.host,
            srcRole: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.srcRole,
            srcService: "cli",
            srcYuno: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.srcYuno,
            user: WSProvier().eventIdentity.kw!.mdIev!.ieventGateStack!.first.user,
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
