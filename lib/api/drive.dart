import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

const _folderType = "application/vnd.google-apps.folder";
const _shortcutType = "application/vnd.google-apps.shortcut";
const _documentType = "application/vnd.google-apps.document";
const _scopes = [DriveApi.driveScope, 'email'];

class GoogleDriveApiManager {
  final env = DotEnv();
  final storage = const FlutterSecureStorage();
  late DriveApi api;
  late int storageUsed, storageTotal;

  Future<List<Item>> login() async {
    await env.load(fileName: '.env');
    final credentials = await getCredentials();
    if (credentials == null) {
      await _loginWithBrowser();
    } else {
      var newToken = await isTokenValid(credentials);
      final client = authenticatedClient(Client(), newToken ?? credentials);
      saveCredentials(
          client.credentials.accessToken,
          client.credentials.refreshToken.toString(),
          client.credentials.idToken.toString());
      api = DriveApi(client);
    }

    final about = await api.about.get($fields: '*');
    storageUsed = int.parse(about.storageQuota!.usage!);
    storageTotal = int.parse(about.storageQuota!.limit!);
    print("Storage used: $storageUsed");
    print("Storage total: $storageTotal");
    print("Storage left: ${storageTotal - storageUsed}");

    print("Getting subfolders size");
    final subfolders = await getSubfolders("root", '');
    print(subfolders);
    return subfolders;
  }

  Future saveCredentials(
      AccessToken token, String refreshToken, String idToken) async {
    await storage.write(key: 'type', value: token.type);
    await storage.write(key: 'data', value: token.data);
    await storage.write(key: 'expiry', value: token.expiry.toString());
    await storage.write(key: 'refreshToken', value: refreshToken);
    await storage.write(key: 'idToken', value: idToken);
  }

  Future deleteCredentials() async {
    await storage.delete(key: 'type');
    await storage.delete(key: 'data');
    await storage.delete(key: 'expiry');
    await storage.delete(key: 'refreshToken');
    await storage.delete(key: 'idToken');
  }

  Future<AccessCredentials?> getCredentials() async {
    final Map<String, dynamic> result = {
      "type": await storage.read(key: 'type'),
      "data": await storage.read(key: 'data'),
      "expiry": await storage.read(key: 'expiry'),
      "refreshToken": await storage.read(key: 'refreshToken'),
      "idToken": await storage.read(key: 'idToken')
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
      _scopes,
      idToken: result['idToken'],
    );
  }

  void _launchAuthInBrowser(Uri url) async {
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not lauch $url';
  }

  Future<void> _loginWithBrowser() async {
    final id = ClientId(
      env.get('GOOGLE_API_ID'),
      env.get('GOOGLE_API_SECRET'),
    );

    var authClient = await clientViaUserConsent(id, _scopes, (url) {
      //Open Url in Browser
      _launchAuthInBrowser(Uri.parse(url));
    });
    await saveCredentials(authClient.credentials.accessToken,
        authClient.credentials.refreshToken!, authClient.credentials.idToken!);
    api = DriveApi(authClient);
  }

  Future<AccessCredentials?> isTokenValid(AccessCredentials credentials) async {
    final resp = await get(Uri.parse(
        'https://www.googleapis.com/oauth2/v2/tokeninfo?id_token=${credentials.idToken}'));
    if (resp.statusCode == 400) {
      final newToken = jsonDecode((await post(
              Uri.parse('https://www.googleapis.com/oauth2/v4/token'),
              body: {
            "client_id": env.get('GOOGLE_API_ID'),
            "client_secret": env.get('GOOGLE_API_SECRET'),
            "refresh_token": credentials.refreshToken,
            "grant_type": "refresh_token",
          }))
          .body);
      saveCredentials(
        AccessToken(
          newToken['token_type'],
          newToken['access_token'],
          DateTime.now()
              .add(
                Duration(
                  seconds: newToken['expires_in'],
                ),
              )
              .toUtc(),
        ),
        credentials.refreshToken.toString(),
        credentials.idToken.toString(),
      );
      return await getCredentials();
    }
    return null;
  }

  Future<List<Item>> getSubfolders(String folderId, String actualPath) async {
    final ret = <Item>[];
    final files = await api.files.list(
      q: "'$folderId' in parents",
      spaces: 'drive',
      $fields: '*',
    );
    for (final file in files.files!) {
      if (file.mimeType == _folderType) {
        final sub = await getSubfolders(file.id!, '$actualPath/${file.id}');
        if (sub.isNotEmpty) ret.addAll(sub);
        ret.add(
          Item(
            id: file.id!,
            name: file.name!,
            size: sub.isEmpty
                ? 0
                : sub
                    .map((e) => e.size)
                    .reduce((value, element) => value + element),
            subfolders: sub,
            path: '$actualPath/${file.id!}',
            type: ItemType.folder,
            mimeType: file.mimeType!,
          ),
        );
        continue;
      }
      print(
          'File: ${file.name}, size: ${file.size}, path: $actualPath, id: ${file.id}, type: ${file.mimeType}');
      if (file.mimeType == _shortcutType) continue;
      ret.add(
        Item(
          id: file.id!,
          name: file.name!,
          size: int.parse(file.size ?? '0'),
          subfolders: [],
          path: '$actualPath/${file.id!}',
          type: ItemType.file,
          mimeType: file.mimeType!,
        ),
      );
    }
    return ret;
  }

  Future<void> downloadFile(Item it) async {
    if (it.mimeType == _documentType) {
    } else {
      Media response = it.mimeType == _documentType
          ? await api.files
              .get(it.id, downloadOptions: DownloadOptions.fullMedia) as Media
          : await api.files.export(it.id, "application/pdf",
              downloadOptions: DownloadOptions.fullMedia) as Media;
      List<int> dataStore = [];
      response.stream.listen((data) {
        dataStore.insertAll(dataStore.length, data);
      }, onDone: () async {
        io.Directory downloadDir = (await getDownloadsDirectory())!;
        String downloadPath = downloadDir.path;
        io.File file = io.File(
            '$downloadPath/${it.name}${it.mimeType == _documentType ? ".pdf" : ""}');
        await file.writeAsBytes(dataStore);
      }, onError: (error) {
        print("Some Error");
      });
    }
  }

  Future<String> getFileName({required String fileId}) async {
    final file = (await api.files.get(fileId,
        $fields: '*', downloadOptions: DownloadOptions.metadata)) as File;
    return file.name!;
  }
}

class Item {
  final String id;
  final String name;
  final int size;
  final String path;
  final ItemType type;
  final List<Item> subfolders;
  final String mimeType;

  Item(
      {required this.id,
      required this.name,
      required this.size,
      required this.subfolders,
      required this.path,
      required this.type,
      required this.mimeType});

  @override
  String toString() {
    return 'Item(id: $id, name: $name, size: $size, path: $path, type: $type, subfolders: $subfolders, mimeType: $mimeType)';
  }
}

enum ItemType { folder, file }
