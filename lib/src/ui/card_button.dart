part of './ui.dart';

class CardButton extends StatelessWidget {
  final String text;
  final String? srcIcon, infoIcon;
  final bool? stateYuno;
  final Color backColor;
  final Color? borderColor, textColor;
  final Function()? onTapCard, onTapInfo;

  const CardButton({
    super.key,
    this.text = '',
    this.borderColor,
    this.backColor = Colors.white,
    this.srcIcon,
    this.onTapCard,
    this.onTapInfo,
    this.infoIcon,
    this.stateYuno,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapCard,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: backColor,
          border: Border.all(
            color: (borderColor != null) ? borderColor! : backColor,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (stateYuno != null)
                  Container(
                    width: 10,
                    height: 10,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (stateYuno == true) ? Colors.green : Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: (stateYuno == true) ? Colors.green : Colors.red,
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                if (srcIcon != null)
                  SvgPicture.asset(
                    srcIcon!,
                    fit: BoxFit.contain,
                    width: 30,
                    height: 30,
                  ),
                if (infoIcon != null)
                  InkWell(
                    onTap: onTapInfo,
                    child: SvgPicture.asset(
                      infoIcon!,
                      fit: BoxFit.contain,
                      width: 25,
                      height: 25,
                    ),
                  ),
              ],
            ),
            if (text != '')
              FittedBox(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
