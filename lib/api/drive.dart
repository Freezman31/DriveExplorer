import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

const _folderType = "application/vnd.google-apps.folder";

class GoogleDriveApiManager {
  final storage = const FlutterSecureStorage();
  late DriveApi api;
  late int storageUsed, storageTotal;

  Future login() async {
    final credentials = await getCredentials();
    if (credentials == null) {
      await _loginWithBrowser();
    } else {
      final client = authenticatedClient(Client(), credentials);
      api = DriveApi(client);
    }

    final about = await api.about.get($fields: '*');
    storageUsed = int.parse(about.storageQuota!.usage!);
    storageTotal = int.parse(about.storageQuota!.limit!);
    print("Storage used: $storageUsed");
    print("Storage total: $storageTotal");
    print("Storage left: ${storageTotal - storageUsed}");

    print("Getting subfolders size");
    final subfolders = await getSubfoldersSize("root", '');
    print(subfolders);
  }

  Future saveCredentials(AccessToken token, String refreshToken) async {
    await storage.write(key: 'type', value: token.type);
    await storage.write(key: 'data', value: token.data);
    await storage.write(key: 'expiry', value: token.expiry.toString());
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future deleteCredentials() async {
    await storage.delete(key: 'type');
    await storage.delete(key: 'data');
    await storage.delete(key: 'expiry');
    await storage.delete(key: 'refreshToken');
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

  void _launchAuthInBrowser(Uri url) async {
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

    var authClient =
        await clientViaUserConsent(id, [DriveApi.driveScope], (url) {
      //Open Url in Browser
      _launchAuthInBrowser(Uri.parse(url));
    });
    await saveCredentials(authClient.credentials.accessToken,
        authClient.credentials.refreshToken!);
    api = DriveApi(authClient);
  }

  Future<List<Item>> getSubfoldersSize(
      String folderId, String actualPath) async {
    final ret = <Item>[];
    final files = await api.files.list(
      q: "'$folderId' in parents",
      spaces: 'drive',
      $fields: '*',
    );
    for (final file in files.files!) {
      if (file.mimeType == _folderType) {
        final sub =
            await getSubfoldersSize(file.id!, '$actualPath/${file.name}');
        ret.addAll(sub);
        ret.add(
          Item(
            id: file.id!,
            name: file.name!,
            size: sub
                .map((e) => e.size)
                .reduce((value, element) => value + element),
            subfolders: sub,
            path: '$actualPath/${file.name!}',
            type: ItemType.folder,
          ),
        );
        continue;
      }
      ret.add(
        Item(
          id: file.id!,
          name: file.name!,
          size: int.parse(file.size!),
          subfolders: [],
          path: '$actualPath/${file.name!}',
          type: ItemType.file,
        ),
      );
    }
    return ret;
  }
}

class Item {
  final String id;
  final String name;
  final int size;
  final String path;
  final ItemType type;
  final List<Item> subfolders;

  Item(
      {required this.id,
      required this.name,
      required this.size,
      required this.subfolders,
      required this.path,
      required this.type});

  @override
  String toString() {
    return 'Item(id: $id, name: $name, size: $size, path: $path, type: $type, subfolders: $subfolders)';
  }
}

enum ItemType { folder, file }
