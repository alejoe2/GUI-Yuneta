part of './pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> servers = ['127.0.0.1', '169.62.218.117', '169.62.218.120', '169.62.218.122', '169.61.27.88'];
  late String serverSelected = servers.first;
  List<String> nameServers = ['Local', 'Dev. GPS', 'Pro. GPS', 'Dev. Video', 'Pro. Video'];
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);
    if (wsProvier.server != '' && wsProvier.ack == true) {
      serverSelected = wsProvier.server;
    }
    ready = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);
    int i = -1;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'YUNETA'),
      drawer: DrawerCustom(eventIdentity: wsProvier.eventIdentity),
      body: (!ready)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ZoomIn(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(
                        'assets/img/yuneta_logo.png',
                      ),
                      width: 250,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton(
                          focusColor: Colors.transparent,
                          value: serverSelected,
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
                          elevation: 16,
                          style: const TextStyle(color: Colors.black, fontSize: 19),
                          underline: Container(
                            height: 2,
                            color: Colors.blueAccent,
                          ),
                          items: servers.map((String opcion) {
                            i++;
                            return DropdownMenuItem(
                              value: opcion,
                              child: Text(nameServers[i]),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              serverSelected = newValue!;
                            });
                          },
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            wsProvier.connectServer(data: serverSelected, name: nameServers[servers.indexWhere((element) => element == serverSelected)]);
                            wsProvier.webSocketListen();
                            wsProvier.send(identityToJson(wsProvier.eventIdentity));
                          },
                          child: const Icon(
                            Icons.send,
                            size: 30,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (wsProvier.server != '' && wsProvier.ack == true && wsProvier.server == serverSelected)
                      SvgPicture.asset(
                        'assets/svg/ic_ok.svg',
                        fit: BoxFit.contain,
                        width: 50,
                        height: 50,
                      ),
                    if (wsProvier.server != '' && wsProvier.ack == false)
                      SvgPicture.asset(
                        'assets/svg/ic-error.svg',
                        fit: BoxFit.contain,
                        width: 50,
                        height: 50,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
