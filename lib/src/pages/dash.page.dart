part of './pages.dart';

class DashPage extends StatelessWidget {
  final Widget child;

  const DashPage({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    //final globalsServices = Provider.of<GlobalsServices>( context );

    return Scaffold(
        body: Column(
      children: [
        Expanded(child: child),
      ],
    ));
  }
}
