part of './pages.dart';

class YunoPages extends StatefulWidget {
  const YunoPages({super.key});

  @override
  State<YunoPages> createState() => _YunoPagesState();
}

class _YunoPagesState extends State<YunoPages> {
  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);

    return Scaffold(
      appBar: customAppBar(context: context, title: 'YUNOS'),
      drawer: DrawerCustom(eventIdentity: wsProvier.eventIdentity),
      body: (wsProvier.yunos.event == null) ? Container() : listYunos(wsProvier, context),
    );
  }
}
