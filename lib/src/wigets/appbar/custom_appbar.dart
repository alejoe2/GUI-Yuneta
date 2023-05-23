part of '../wigets.dart';

AppBar customAppBar({required BuildContext context, String title = ''}) {
  final authProvider = Provider.of<AuthProvider>(context);
  final wsProvier = Provider.of<WSProvier>(context);
  return AppBar(
    title: Center(child: Text(title)),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          children: [
            if (wsProvier.ack == true)
              Text(
                'Server: ${wsProvier.serverName}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(width: 20),
            InkWell(
              onTap: () async {
                final TokenResponse token = Storages.getToken;
                token.accessToken = null;
                await Storages.setToken(data: token);
                await authProvider.autenticated();
              },
              child: const Icon(
                Icons.logout_outlined,
                size: 26.0,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
