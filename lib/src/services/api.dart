part of './services.dart';

Future<String> getPublicIp() async {
  var response = await http.get(Uri.parse('https://api.ipify.org/'));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get public IP');
  }
}
