part of './pages.dart';

class SymmaryPage extends StatefulWidget {
  const SymmaryPage({super.key});

  @override
  State<SymmaryPage> createState() => _SymmaryPageState();
}

class _SymmaryPageState extends State<SymmaryPage> {
  bool ready = false;
  int open = -1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final wsProvier = Provider.of<WSProvier>(context, listen: false);
    wsProvier.displaySummary.kw == null;
    ready = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final wsProvier = Provider.of<WSProvier>(context);
    int x = -1;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'SUMARIO'),
      drawer: DrawerCustom(eventIdentity: wsProvier.eventIdentity),
      body: (wsProvier.displaySummary.kw == null && ready)
          ? Container()
          : Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 1000,
                child: ListView(
                  children: [
                    ...wsProvier.displaySummary.kw!.data.entries.map((entry) {
                      x++;
                      return FadeInUp(child: Card(child: lista(x, entry)));
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget lista(int x, entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (x == open) {
              open = -1;
            } else {
              open = x;
            }
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SvgPicture.asset(
                  getTypeIcon(entry.key),
                  fit: BoxFit.contain,
                  width: 25,
                ),
                const SizedBox(width: 5),
                Text('${entry.key}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                if (x != open) const Icon(Icons.arrow_drop_down),
                if (x == open) const Icon(Icons.arrow_drop_up)
              ],
            ),
          ),
        ),
        if (entry.value is Map && x == open)
          ...entry.value.entries.map((entry2) {
            if (entry2.value is Map) {
              return ZoomIn(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${entry2.key}: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (entry2.value is Map)
                        ...entry2.value.entries.map((entry3) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 30, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [Text('${entry3.key}', style: const TextStyle(fontWeight: FontWeight.w600)), if (entry3.value is! Map) Text(': ${entry3.value}')],
                                ),
                                if (entry3.value is Map)
                                  ...entry3.value.entries.map((entry4) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 20, bottom: 5),
                                      child: Row(
                                        children: [
                                          Text('- ${entry4.key}: ', style: const TextStyle(fontWeight: FontWeight.w500)),
                                          Text('${entry4.value}'),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              ],
                            ),
                          );
                        }).toList(),
                      if (entry2.value is! Map) Text('${entry2.value}'),
                    ],
                  ),
                ),
              );
            }
            if (entry2.value is! Map) {
              return ZoomIn(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 5),
                  child: Row(
                    children: [
                      Text('${entry2.key} : ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (entry2.value is Map)
                        ...entry2.value.entries.map((entry3) {
                          return Column(
                            children: [
                              Text('${entry3.key} : ${entry3.value}'),
                            ],
                          );
                        }).toList(),
                      if (entry2.value is! Map) Text('${entry2.value}'),
                    ],
                  ),
                ),
              );
            }
          }).toList(),
        if (entry.value is! Map && x == open)
          ZoomIn(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  String getTypeIcon(String data) {
    int i = -1;
    if (data.toUpperCase().contains('counter'.toUpperCase())) i = 0;
    if (data.toUpperCase().contains('warning'.toUpperCase())) i = 4;
    if (data.toUpperCase().contains('error'.toUpperCase())) i = 3;
    if (data.toUpperCase().contains('alert'.toUpperCase())) i = 1;
    if (data.toUpperCase().contains('crit'.toUpperCase())) i = 2;
    switch (i) {
      case 0:
        return 'assets/svg/ic_grafic.svg';
      case 1:
        return 'assets/svg/ic-alert.svg';
      case 2:
        return 'assets/svg/ic-crit.svg';
      case 3:
        return 'assets/svg/ic-error.svg';
      case 4:
        return 'assets/svg/ic-warning.svg';
      case 5:
        return 'assets/svg/ic-notice.svg';
      case 6:
        return 'assets/svg/ic-info.svg';
      case 7:
        return 'assets/svg/ic-debug.svg';
      default:
        return 'assets/svg/ic-info.svg';
    }
  }
}
