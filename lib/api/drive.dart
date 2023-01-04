import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleDriveApiManager {
  final storage = const FlutterSecureStorage();
  late DriveApi api;

  Future login() async {
    final credentials = await getCredentials();
    if (credentials == null) {
      _loginWithBrowser();
    } else {
      final client = Client();
      authenticatedClient(client, credentials);
      api = DriveApi(client);
      client.close();
    }
  }

  Future saveCredentials(AccessToken token, String refreshToken) async {
    await storage.write(key: 'type', value: token.type);
    await storage.write(key: 'data', value: token.data);
    await storage.write(key: 'expiry', value: token.expiry.toString());
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<AccessCredentials?> getCredentials() async {
    final Map<String, dynamic> result = {
      "type": await storage.read(key: 'type'),
      "data": await storage.read(key: 'data'),
      "expiry": await storage.read(key: 'expiry'),
      "refreshToken": await storage.read(key: 'refreshToken'),
    };
    if (result['type'] == null) {
      return null;
    }
    return AccessCredentials(
      AccessToken(
        result['type']!,
        result['data']!,
        DateTime.parse(result['expiry']!),
      ),
      result['refreshToken']!,
      [DriveApi.driveScope],
    );
  }

  void _lauchAuthInBrowser(Uri url) async {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not lauch $url';
  }

  Future<void> _loginWithBrowser() async {
    final env = DotEnv();
    await env.load(fileName: '.env');
    final id = ClientId(
      env.get('GOOGLE_API_ID'),
      env.get('GOOGLE_API_SECRET'),
    );
    final client = Client();

    obtainAccessCredentialsViaUserConsent(id, [DriveApi.driveScope], client,
            (url) => _lauchAuthInBrowser(Uri.parse(url)))
        .then((AccessCredentials credentials) {
      api = DriveApi(client);
      client.close();
      saveCredentials(credentials.accessToken, credentials.refreshToken!);
    });
  }
}
