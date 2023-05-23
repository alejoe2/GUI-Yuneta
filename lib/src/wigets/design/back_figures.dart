part of '../wigets.dart';

class BackCircle extends StatelessWidget {
  final Color color;
  final double size;
  const BackCircle({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(0.85)),
    );
  }
}

class BackSquare extends StatelessWidget {
  final Color color;
  const BackSquare({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(NavigatonServices.navigatiorKey.currentContext!).size;
    return Container(
      width: 200,
      height: 200,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20), color: color.withOpacity(0.8)),
    );
  }
}
