part of '../wigets.dart';

Future<void> showAlertOK({String? title, required String content, String? icon}) async {
  return showDialog(
      context: NavigatonServices.navigatiorKey.currentContext!,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (title != null)
              ? Center(
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(icon, fit: BoxFit.contain, width: 25),
                      ),
                    Text(title),
                  ],
                ))
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(content),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
